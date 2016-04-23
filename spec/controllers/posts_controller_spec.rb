require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::TestHelpers

  describe "POST :create" do
    let(:user) { create :user }
    let(:body) { "blah blah teleblah" }

    before do
      sign_in user
      post :create, post: { body: body }
    end

    it "creates associations between the user and the user's post" do
      expect(user.posts.count).to eq 1
      expect(Post.first.users.to_a).to eq [user]
    end

    it "creates a post with the correct body" do
      expect(Post.first.body).to eq body
    end
  end
end
