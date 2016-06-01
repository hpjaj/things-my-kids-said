require 'rails_helper'

describe 'Signing out of the app' do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user }

  before do
    sign_into_app user
    visit home_path
    expect(current_path).to eq home_path
    page.find(:xpath, "//a[@href='/users/sign_out']").click
  end

  it "logs in a new user" do
    expect(current_path).to eq root_path
  end
end
