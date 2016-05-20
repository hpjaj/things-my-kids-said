require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::TestHelpers

  let(:user) { create :user }
  let!(:kid) { create :kid, users: [user] }
  let(:body) { "blah blah teleblah" }
  let(:age)  { Date.current }

  before { sign_in user }

  describe "POST :create" do
    context "user has one kid" do
      before do
        post :create, post: { kids_age: age, body: body, kid_id: kid.id.to_s }
      end

      it "creates associations between the user and the user's post" do
        expect(user.posts.count).to eq 1
        expect(Post.first.user).to eq user
      end

      it "creates associations between the user's kid and the post" do
        child = user.kids.first

        expect(Post.first.kid).to eq child
      end

      it "creates a post with the correct body" do
        expect(Post.first.body).to eq body
      end
    end

    context "user has more than one kid" do
      let!(:kid_2) { create :kid, users: [user] }

      before do
        post :create, post: { kids_age: age, body: body, kid_id: kid_2.id }
      end

      it "user has two kids" do
        expect(user.kids).to eq [kid, kid_2]
      end

      it "associates the post with the kids that the user selected" do
        expect(Post.first.kid).to eq kid_2
      end

      it "creates one post" do
        expect(user.posts.count).to eq 1
      end
    end

    context "user selects custom_age" do
      before do
        post :create, post: { kids_age: 'custom_age', body: body, kid_id: kid.id.to_s, years_old: '4', months_old: '11' }
      end

      it "creates a post with a custom age" do
        date_said = Post.first.kid.birthdate + 4.years + 11.months

        expect(Post.first.date_said).to eq date_said
      end
    end
  end

  describe "POST :update" do
    let(:quote) { create :post, user: user, kid: kid }
    let(:kid_2) { create :kid, users: [user] }

    context "happy path" do
      before do
        post :update, id: quote.id.to_s, post: { kids_age: age, body: "new and improved", kid_id: kid_2.id.to_s }
        quote.reload
      end

      it "updates a Post's body" do
        expect(quote.body).to eq "new and improved"
      end

      it "updates a Post's body" do
        expect(quote.kid_id).to eq kid_2.id
      end
    end

    context "user selects custom_age" do
      before do
        post :update, id: quote.id.to_s, post: { kids_age: 'custom_age', body: body, kid_id: kid.id.to_s, years_old: '4', months_old: '11' }
      end

      it "updates a post with a custom age" do
        date_said = Post.first.kid.birthdate + 4.years + 11.months

        expect(Post.first.date_said).to eq date_said
      end
    end
  end

  describe "DELETE :destroy" do
    let!(:quote) { create :post, user: user, kid: kid }

    it "successfully deletes a Post" do
      expect{ delete :destroy, id: quote.id }.to change{ Post.count }.by(-1)
    end
  end
end
