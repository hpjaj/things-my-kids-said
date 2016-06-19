require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:dad)  { create :user, first_name: 'Frank' }
  let(:kid)  { create :kid }

  describe "associations" do
    context "friend_and_families" do
      before { user.following << kid }

      it "user.following are the kids a user is following" do
        expect(user.following).to eq [kid]
      end

      it "creates a new FriendAndFamily record" do
        expect(FriendAndFamily.count).to eq 1
      end

      it "destroying user/follower destroys the associated FriendAndFamily record" do
        expect{ user.destroy }.to change{ FriendAndFamily.count }.by(-1)
      end
    end

    context "kids" do
      before do
        user.kids << kid
        dad.kids << kid
      end

      it "two users/parents can have one kid" do
        expect(user.kids).to eq [kid]
        expect(dad.kids).to eq [kid]
      end
    end
  end

  describe "##potential_friends_and_family_members_of" do
    let(:son)      { create :kid, :users => [dad] }
    let(:daughter) { create :kid, :users => [dad] }
    let(:mom)      { create :user }
    let!(:friend)  { create :user }

    before do
      mom.kids << [son, daughter]
      expect(mom.kids).to include(son, daughter)
      expect(dad.kids).to include(son, daughter)
    end

    let(:results) { User.potential_friends_and_family_members_of(dad) }

    it "returns all of the users that are not parents of any of the user's kids" do
      expect(results).to eq [friend]
    end

    it "does not return the current user" do
      expect(results).to_not include(dad)
    end

    it "does not return either of the parents of the current user's kids" do
      expect(results).to_not include(mom)
    end
  end

  describe "#fellow_parent_s" do
    let(:son)      { create :kid, :users => [dad], first_name: 'Steven' }
    let(:daughter) { create :kid, :users => [dad], first_name: 'Janie' }
    let(:spouse)   { create :user, first_name: 'Susan' }
    let(:friend)   { create :user }

    before do
      son.parents << spouse
      friend.following << [son, daughter]
    end

    it "returns the user's spouse, based on the current user's kids" do
      expect(dad.fellow_parent_s).to eq [spouse]
      expect(spouse.fellow_parent_s).to eq [dad]
    end

    it "does not include the user it is being called on" do
      expect(dad.fellow_parent_s).to_not include(dad)
      expect(spouse.fellow_parent_s).to_not include(spouse)
    end

    it "does not include the kids' friends & family" do
      expect(dad.fellow_parent_s).to_not include(friend)
      expect(spouse.fellow_parent_s).to_not include(friend)
    end

    context "kid has more than two parents" do
      let(:biological_mom) { create :user, first_name: 'Jennifer' }

      before { son.parents << biological_mom }

      it "returns the user's spouses, based on the current user's kids" do
        expect(son.parents).to include(dad, spouse, biological_mom)
        expect(dad.fellow_parent_s).to include(spouse, biological_mom)
        expect(spouse.fellow_parent_s).to include(dad, biological_mom)
        expect(biological_mom.fellow_parent_s).to include(dad, spouse)
        expect(biological_mom.fellow_parent_s).to_not include(friend)
      end

      context "parents new spouse not given parent permission" do
        let(:new_husband) { create :user, first_name: 'Tom' }
        let!(:other_kid)  { create :kid, :users => [new_husband, biological_mom] }

        before do
          expect(other_kid.parents.count).to eq 2
          expect(other_kid.parents).to include(new_husband, biological_mom)
          expect(son.parents.count).to eq 3
          expect(son.parents).to include(dad, spouse, biological_mom)
        end

        it "does not include a new spouse-in-law-relation that does not have parent permissions" do
          expect(new_husband.fellow_parent_s).to eq [biological_mom]
          expect(biological_mom.fellow_parent_s).to include(dad, spouse, new_husband)
        end
      end
    end
  end
end
