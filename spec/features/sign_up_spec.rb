require 'rails_helper'

describe 'Signing up for an account' do

  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    visit root_path
    expect(current_path).to eq root_path
    click_link "Sign Up"
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
  end

  it "logs in a new user" do
    expect(current_path).to eq home_path
  end
end
