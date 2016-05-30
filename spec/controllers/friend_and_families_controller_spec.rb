require 'rails_helper'

RSpec.describe FriendAndFamiliesController, type: :controller do
  include Devise::TestHelpers

  let(:dad)    { create :user }
  let(:kid)    { create :kid, users: [dad] }
  let(:family) { create :user }

  describe "POST :create" do
    before do
      sign_in dad
      post :create, friend_and_family: { kid_id: kid.id.to_s, follower_id: family.id.to_s, can_create_posts: '0' }
    end

    it "creates a new FriendAndFamily successfully" do
      expect(FriendAndFamily.count).to eq 1
      expect(FriendAndFamily.first.kid_id).to eq kid.id
      expect(FriendAndFamily.first.follower_id).to eq family.id
      expect(FriendAndFamily.first.can_create_posts).to be false
    end

    it "does not permit a duplicate FriendAndFamily record" do
      expect{
        post :create, friend_and_family: { kid_id: kid.id.to_s, follower_id: family.id.to_s, can_create_posts: '0' }
      }.to change{ FriendAndFamily.count }.by(0)
    end
  end

  describe "PATCH :update" do
    let!(:friend_and_family) { FriendAndFamily.create(kid_id: kid.id, follower_id: family.id, can_create_posts: false) }

    before do
      sign_in dad
      expect(FriendAndFamily.count).to eq 1
    end

    it "updates an existing FriendAndFamily record" do
      expect(friend_and_family.can_create_posts).to be false

      patch :update, id: friend_and_family.id, friend_and_family: { kid_id: kid.id.to_s, follower_id: family.id.to_s, can_create_posts: '1' }
      friend_and_family.reload

      expect(friend_and_family.can_create_posts).to be true
    end

    it "does not allow the user to mistakenly duplicate an existing FriendAndFamily record" do
      friend = create :user
      FriendAndFamily.create(kid_id: kid.id, follower_id: friend.id, can_create_posts: true)

      expect{
        patch :update, id: friend_and_family.id, friend_and_family: { kid_id: kid.id.to_s, follower_id: friend.id.to_s, can_create_posts: '1' }
      }.to change{ FriendAndFamily.count }.by(0)
    end
  end


end
