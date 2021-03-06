require 'rails_helper'

RSpec.describe Kid, type: :model do
  let(:user)  { create :user }
  let(:kid)   { create :kid }
  let(:janie) { create :kid }

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:birthdate) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:created_by) }

    describe "#cannot_create_duplicate" do
      let(:date)   { Date.new(2012, 1, 15) }
      let(:dad)    { create :user, first_name: 'Tom' }
      let(:mom)    { create :user, first_name: 'Susan' }
      let(:friend) { create :user, first_name: 'Brian' }
      let!(:son)   { create :kid, users: [dad, mom], gender: Kid::BOY, birthdate: date, first_name: 'jack', last_name: 'johnson', created_by: dad.id }

      before do
        expect(Kid.count).to eq 1
        expect(son.parents).to include(mom, dad)
      end

      context "fellow parent creating duplicate of their own kid" do
        it "will raise an error when a parent tries to create a kid that already exists underneath the set of parents" do
          expect{
            create :kid, users: [dad, mom], gender: Kid::BOY, birthdate: date, first_name: 'jack', last_name: 'johnson', created_by: mom.id
            }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "another user creating a kid with identical information to a kid in the database that is not theirs" do
        it "will create a new kid" do
          expect{
            create :kid, users: [friend], gender: Kid::BOY, birthdate: date, first_name: 'jack', last_name: 'johnson', created_by: friend.id
            }.to change{ Kid.count }.by(1)
        end

        it "will not raise an error" do
          expect{
            create :kid, users: [friend], gender: Kid::BOY, birthdate: date, first_name: 'jack', last_name: 'johnson', created_by: friend.id
            }.to_not raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe "associations" do
    context "friend_and_families" do
      before { kid.followers << user }

      it "kid.followers are the friends and family of a kid" do
        expect(kid.followers).to eq [user]
      end

      it "creates a new FriendAndFamily record" do
        expect(FriendAndFamily.count).to eq 1
      end

      it "destroying a kid destroys the associated FriendAndFamily record" do
        expect{ kid.destroy }.to change{ FriendAndFamily.count }.by(-1)
      end
    end

    context "users" do
      before do
        kid.parents << user
        janie.parents << user
      end

      it "two kids can have one parent" do
        expect(kid.parents.pluck(:id).include?(user.id)).to be true
        expect(janie.parents.pluck(:id).include?(user.id)).to be true
      end
    end
  end

  describe "##users_friends_and_families_kids_that_they_can_create_posts_for" do
    let(:friends_kid) { create :kid }
    let(:son)         { create :kid }
    let(:niece)       { create :kid }

    before do
      son.parents << user
      niece.followers << user
      friends_kid.followers << user
      son_permission = user.friend_and_families.where(kid_id: niece.id).first
      son_permission.update!(can_create_posts: true)
    end

    let(:results) { Kid.users_friends_and_families_kids_that_they_can_create_posts_for(user) }

    it "returns kids that the user was given permission to create post for" do
      expect(results).to eq [niece]
    end

    it "does not return the user's own kids" do
      expect(user.kids).to include(son)
      expect(results).to_not include(son)
    end

    it "does not return kids that the user is following, but does not have permission to create posts for" do
      expect(user.following).to include(niece, friends_kid)
      expect(results).to_not include(friends_kid)
    end
  end
end
