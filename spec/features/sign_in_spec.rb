require 'rails_helper'

describe 'Signing in as an existing user' do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user }

  before do
    visit root_path
    expect(current_path).to eq root_path
    click_link "sign-in-button"
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  it "logs in an existing user" do
    expect(current_path).to eq home_path
  end
end
