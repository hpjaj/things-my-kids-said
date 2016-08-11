require 'rails_helper'

RSpec.describe PicturesController, type: :controller do
  include Devise::TestHelpers

  describe "DELETE :destroy" do
    let(:user) { create :user }
    let(:kid) { create :kid, users: [user] }

    before do
      sign_in user
      create_profile_picture_for(kid, user)
      create_profile_picture_for(kid, user)
      expect(kid.pictures.profile_pictures.count).to eq 2
      create :post, user: user, kid: kid, picture_id: kid.pictures.first.id
      create :post, user: user, kid: kid, picture_id: kid.pictures.first.id
      create :post, user: user, kid: kid, picture_id: kid.pictures.last.id
      expect(Post.count).to eq 3
      expect(Picture.count).to eq 2

      delete :destroy, id: kid.pictures.first.id
    end

    it "deletes the picture" do
      expect(Picture.count).to eq 1
    end

    it "sets the picture's posts' picture_id == nil" do
      expect(Post.first.picture_id).to be nil
      expect(Post.second.picture_id).to be nil
    end

    it "does not alter posts that are not associated with the deleted picture" do
      expect(Post.last.picture_id).to be kid.pictures.last.id
    end
  end
end
