require 'rails_helper'

describe PostPicture do
  let(:parent) { create :user }
  let(:kid)    { create :kid, users: [parent] }
  let(:age)    { Date.current }
  let(:body)   { "blah blah teleblah" }

  describe "#set_picture_id" do
    context "kid has a profile picture" do
      before { create_profile_picture_for(kid, parent) }

      let(:params) { { post: { kids_age: age, body: body, kid_id: kid.id.to_s } } }
      let!(:post) { create :post, user: parent, kid: kid }
      let(:profile_pic_id) { kid.pictures.profile_pictures.first.id }

      before { PostPicture.new(params, post, parent).set_picture_id }

      context "creating their first post" do
        it "sets the post's picture_id to the profile picture's id" do
          expect(post.picture_id).to eq profile_pic_id
        end

        context "previous post has a picture" do
          before do
            create :post, user: parent, kid: kid, picture_id: 8888
            create :post, user: parent, kid: kid, picture_id: 9999
            expect(Post.count).to eq 3
          end

          it "sets the post's picture_id to the previous post's picture_id" do
            last_post_picture_id = Post.last.picture_id
            post = create :post, user: parent, kid: kid

            PostPicture.new(params, post, parent).set_picture_id

            expect(post.picture_id).to eq last_post_picture_id
          end
        end
      end
    end

    context "post already has a picture" do
      let!(:post_1) { create :post, user: parent, kid: kid, picture_id: 8888 }
      let!(:post_2) { create :post, user: parent, kid: kid, picture_id: 9999 }

      context "user adds a new picture to their post" do
        let(:params) { { post: { kids_age: age, body: body, kid_id: kid.id.to_s, picture: { photo: dispatch_upload } } } }

        it "sets the post's picture_id to the new picture's id" do
          posts_picture_id = post_1.picture_id
          new_pictures_id = PostPicture.new(params, post_1, parent).set_picture_id

          expect(posts_picture_id).to_not eq new_pictures_id
          expect(kid.pictures.pluck(:id)).to include new_pictures_id
        end
      end

      context "user updates the post and does not change the existing picture" do
        let(:new_body) { "New and improved" }
        let(:params) { { post: { kids_age: age, body: new_body, kid_id: kid.id.to_s } } }

        it "does not alter the post's picture_id" do
          original_picture_id = post_1.picture_id

          PostPicture.new(params, post_1, parent).set_picture_id

          expect(post_1.picture_id).to eq original_picture_id
        end
      end
    end
  end

  describe "#determine_quotes_picture" do
    let(:params) { { post: { kids_age: age, body: body, kid_id: kid.id.to_s } } }

    context "kid has a profile picture" do
      before { create_profile_picture_for(kid, parent) }

      let(:profile_pic_id) { kid.pictures.profile_pictures.first.id }

      context "kid has at least one post with a picture" do
        let!(:post_1) { create :post, user: parent, kid: kid, picture_id: 8888 }
        let!(:post_2) { create :post, user: parent, kid: kid, picture_id: 9999 }

        it "returns the most recent post's picture_id" do
          result = PostPicture.new(params, post_1, parent).determine_quotes_picture(kid.id)

          expect(result).to eq post_2.picture_id
        end
      end

      context "kid's posts have no pictures" do
        it "returns the kid's profile picture's id" do
          post = create :post, user: parent, kid: kid
          result = PostPicture.new(params, post, parent).determine_quotes_picture(kid.id)

          expect(result).to eq profile_pic_id
        end
      end
    end

    context "kid does not have any pictures of any type" do
      it "returns nil" do
        post = create :post, user: parent, kid: kid
        result = PostPicture.new(params, post, parent).determine_quotes_picture(kid.id)

        expect(result).to be nil
      end
    end
  end

end
