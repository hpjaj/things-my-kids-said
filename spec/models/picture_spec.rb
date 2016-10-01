require 'rails_helper'

RSpec.describe Picture, type: :model do
  let(:user) { create :user }
  let(:kid) { create :kid }
  let(:params_with_model) { params_from_kid_controller(user, dispatch_upload) }

  describe ".add_picture" do
    it 'creates a new picture from the supplied arguements' do
      Picture.add_picture(user, params_with_model, kid.id)

      expect(Picture.count).to eq 1
    end
  end
end
