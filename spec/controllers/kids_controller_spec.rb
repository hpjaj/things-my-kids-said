require 'rails_helper'

RSpec.describe KidsController, type: :controller do
  include Devise::TestHelpers

  describe "POST :create" do
    let(:user)  { create :user }
    let(:attrs) { { name: 'Jackie', birthdate: '2010-04-16', gender: 'female' } }

    before do
      sign_in user
      post :create, kid: attrs
    end

    it "creates associations between the user and the user's kid" do
      expect(user.kids.count).to eq 1
      expect(Kid.first.users.to_a).to eq [user]
    end

    it "creates a kid with the correct attributes" do
      expect(Kid.first.name).to eq attrs[:name]
      expect(Kid.first.birthdate).to eq attrs[:birthdate].to_date
      expect(Kid.first.gender).to eq attrs[:gender]
    end
  end
end
