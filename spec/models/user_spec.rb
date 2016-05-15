require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:dad)  { create :user }
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
end
