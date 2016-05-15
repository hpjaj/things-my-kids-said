require 'rails_helper'

RSpec.describe Kid, type: :model do
  let(:user)  { create :user }
  let(:kid)   { create :kid }
  let(:janie) { create :kid }

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
end
