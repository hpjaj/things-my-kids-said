require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::TestHelpers
  render_views

  let(:user) { create :user }
  let!(:kid) { create :kid, users: [user] }
  let(:body) { "blah blah teleblah" }
  let(:age)  { Date.current }
  let(:friends) { Visibility::FRIENDS }

  before { sign_in user }

  describe "POST :create" do
    context "user has one kid" do
      before do
        post :create, post: { kids_age: age, body: body, kid_id: kid.id.to_s, visible_to: friends }
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
        post :create, post: { kids_age: age, body: body, kid_id: kid_2.id, visible_to: friends }
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
        post :create, post: { kids_age: 'custom_age', body: body, kid_id: kid.id.to_s, years_old: '4', months_old: '11', visible_to: friends }
      end

      it "creates a post with a custom age" do
        date_said = Post.first.kid.birthdate + 4.years + 11.months

        expect(Post.first.date_said).to eq date_said
      end
    end

    context "with an uploaded picture" do
      before do
        post :create, post: { kids_age: age, body: body, kid_id: kid.id.to_s, visible_to: friends, picture: { photo: dispatch_upload } }
      end

      it "creates a post" do
        expect(Post.count).to eq 1
      end

      it "creates a new Picture for the post" do
        expect(Picture.count).to eq 1
        expect(Post.first.picture).to eq Picture.first
      end

      it "does not create a new profile picture" do
        expect(Picture.first.profile_picture).to be false
      end

      it "creates a picture for the post's kid" do
        expect(kid.pictures.last).to eq Picture.first
      end
    end

    context "kid has a profile picture" do
      before do
        create_profile_picture_for(kid, user)
        expect(kid.pictures.profile_pictures.count).to eq 1
      end

      context "no new picture is uploaded" do
        before do
          post :create, post: { kids_age: age, body: body, kid_id: kid.id.to_s, visible_to: friends }
        end

        it "creates a post" do
          expect(Post.count).to eq 1
        end

        it "links the kid's profile picture to the new post" do
          kid_picture_id = kid.pictures.profile_pictures.last_updated.id

          expect(Post.first.picture_id).to eq kid_picture_id
        end
      end

      context "uploads a new picture" do
        before do
          post :create, post: { kids_age: age, body: body, kid_id: kid.id.to_s, visible_to: friends, picture: { photo: dispatch_upload } }
        end

        it "creates a post" do
          expect(Post.count).to eq 1
        end

        it "creates a new picture for the post and kid" do
          expect(Picture.count).to eq 2
          expect(Kid.first.pictures.count).to eq 2
        end

        it "links the kid's new picture to the new post" do
          kid_picture_id = kid.pictures.last.id

          expect(Post.first.picture_id).to eq kid_picture_id
        end

        it "creates a picture with profile_picture == false" do
          expect(Post.first.picture.profile_picture).to be false
        end
      end

      context "uploads a new picture with blank Post body" do
        before do
          post :create, post: { kids_age: age, body: nil, kid_id: kid.id.to_s, visible_to: friends, picture: { photo: dispatch_upload } }
        end

        it "does not create a new post" do
          expect(Post.count).to eq 0
        end

        it "does not create a new picture" do
          expect(Picture.count).to eq 1
          expect(Kid.first.pictures.count).to eq 1
        end
      end
    end
  end

  describe "PATCH :update" do
    let(:quote) { create :post, user: user, kid: kid }
    let(:kid_2) { create :kid, users: [user] }

    context "happy path" do
      before do
        patch :update, id: quote.id.to_s, post: { kids_age: age, body: "new and improved", kid_id: kid_2.id.to_s, visible_to: friends }
        quote.reload
      end

      it "updates a Post's body" do
        expect(quote.body).to eq "new and improved"
      end

      it "updates a Post's body" do
        expect(quote.kid_id).to eq kid_2.id
      end
    end

    context "user changes date the quote was said" do
      before do
        patch :update, id: quote.id.to_s, post: { date_said: Date.current, body: body, kid_id: kid.id.to_s, visible_to: friends }
      end

      it "updates a post with a custom age" do
        expect(Post.first.date_said).to eq Date.current
      end
    end

    context "adds a picture to a picture-less post" do
      before do
        patch :update, id: quote.id.to_s, post: { kids_age: age, body: "new and improved", visible_to: friends, kid_id: kid_2.id.to_s, picture: { photo: dispatch_upload } }
      end

      it "updates the current post" do
        expect(Post.count).to eq 1
        expect(Post.first.valid?).to be true
      end

      it "creates a new Picture for the post" do
        expect(Picture.count).to eq 1
        expect(Post.first.picture).to eq Picture.first
      end

      it "does not create a new profile picture" do
        expect(Picture.first.profile_picture).to be false
      end

      it "creates a picture for the post's kid" do
        expect(kid_2.pictures.last).to eq Picture.first
      end
    end

    context "replaces picture on post with a new picture" do
      before do
        create_profile_picture_for(kid_2, user)
        expect(kid_2.pictures.profile_pictures.count).to eq 1
        patch :update, id: quote.id.to_s, post: { kids_age: age, body: "new and improved", visible_to: friends, kid_id: kid_2.id.to_s, picture: { photo: dispatch_upload } }
      end

      it "updates the current post" do
        expect(Post.count).to eq 1
        expect(Post.first.valid?).to be true
      end

      it "creates a new picture for the post and kid" do
        expect(Picture.count).to eq 2
        expect(kid_2.pictures.count).to eq 2
      end

      it "links the kid's new picture to the new post" do
        kid_picture_id = kid_2.pictures.last.id

        expect(Post.first.picture_id).to eq kid_picture_id
      end

      it "creates a picture with profile_picture == false" do
        expect(Post.first.picture.profile_picture).to be false
      end
    end

    context "replaces picture on post with a new picture with blank Post body" do
      before do
        create_profile_picture_for(kid_2, user)
        expect(kid_2.pictures.profile_pictures.count).to eq 1
        patch :update, id: quote.id.to_s, post: { kids_age: age, body: nil, visible_to: friends, kid_id: kid_2.id.to_s, picture: { photo: dispatch_upload } }
      end

      it "does not change the post.kid_id to kid_2" do
        expect(quote.kid_id).to eq kid.id
      end

      it "does not add a picture to the Post" do
        expect(quote.picture_id).to be nil
      end
    end
  end

  describe "DELETE :destroy" do
    let!(:quote) { create :post, user: user, kid: kid }

    it "successfully deletes a Post" do
      expect{ delete :destroy, id: quote.id }.to change{ Post.count }.by(-1)
    end
  end

  describe "edge cases" do
    context "custom_age is selected, and kid_id is left blank" do
      let!(:kid_2) { create :kid, users: [user] }

      it "does not create a new Post" do
        expect{
          post :create, post: { kids_age: 'custom_age', body: body, kid_id: '', years_old: '4', months_old: '11', visible_to: friends }
        }.to change{ Post.count }.by(0)
      end

      it "displays error 'Must choose a kid'" do
        post :create, post: { kids_age: 'custom_age', body: body, kid_id: '', years_old: '4', months_old: '11', visible_to: friends }

        expect(response.body).to have_content "can't be blank"
      end
    end

    context "User has three posts, each one with a unique picture." do
      let(:kid_2) { create :kid, users: [user] }

      before do
        # create kid's profile picture
        create_profile_picture_for(kid_2, user)
        expect(kid_2.pictures.profile_pictures.count).to eq 1

        # create first post, which inherits the profile picture
        post :create, post: { kids_age: age, body: body, kid_id: kid_2.id.to_s, visible_to: friends }
        expect(Post.first.picture_id).to eq Picture.first.id

        # create second post with a new picture
        post :create, post: { kids_age: age, body: body, kid_id: kid_2.id.to_s, visible_to: friends, picture: { photo: dispatch_upload } }
        expect(kid_2.pictures.count).to eq 2
        expect(Post.last.picture_id).to eq Picture.last.id

        # create third post with another new picture
        post :create, post: { kids_age: age, body: body, kid_id: kid_2.id.to_s, visible_to: friends, picture: { photo: dispatch_upload } }
        expect(kid_2.pictures.count).to eq 3
        expect(Post.last.picture_id).to eq Picture.last.id
      end

      let(:todays_post) { Post.last }
      let(:todays_picture) { Picture.last }
      let(:yesterdays_post) { Post.second }
      let(:yesterdays_picture) { Picture.second }
      let(:two_days_ago_post) { Post.first }
      let(:two_days_ago_picture) { Picture.first }
      let(:new_body) { "new and improved" }

      it "after saving yesterday's post, it still has yeseterday's picture on it" do
        patch :update, id: yesterdays_post.id.to_s, post: { kids_age: age, body: new_body, kid_id: kid_2.id.to_s, visible_to: friends }
        yesterdays_post.reload

        expect(yesterdays_post.body).to eq new_body
        expect(yesterdays_post.picture_id).to eq yesterdays_picture.id
      end
    end
  end
end
