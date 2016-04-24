require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::TestHelpers

  describe "POST :create" do
    let(:user) { create :user }
    let!(:kid) { create :kid, users: [user] }
    let(:body) { "blah blah teleblah" }

    context "user has one kid" do
      before do
        sign_in user
        post :create, post: { body: body, kid_ids: kid.id.to_s }
      end

      it "creates associations between the user and the user's post" do
        expect(user.posts.count).to eq 1
        expect(Post.first.users.to_a).to eq [user]
      end

      it "creates associations between the user's kid and the post" do
        child = user.kids.first

        expect(Post.first.kids.to_a).to eq [child]
      end

      it "creates a post with the correct body" do
        expect(Post.first.body).to eq body
      end
    end

    context "user has more than one kid" do
      let!(:kid_2) { create :kid, users: [user] }

      before do
        sign_in user
        post :create, post: { body: body, kid_ids: [kid.id, kid_2.id] }
      end

      it "user has two kids" do
        expect(user.kids).to eq [kid, kid_2]
      end

      it "associates the post with the kids that the user selected" do
        expect(Post.first.kids).to eq [kid, kid_2]
      end

      it "creates one post" do
        expect(user.posts.count).to eq 1
      end
    end

    context "with an invalid kid id" do
      before do
        sign_in user
        post :create, post: { body: body, kid_ids: kid.id.to_i + 1 }
      end

      it "should not create a new post" do
        expect(Post.count).to eq 0
      end
    end
  end
end
