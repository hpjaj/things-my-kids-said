require 'rails_helper'

describe 'Creating a new kid' do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user }

  before { sign_into_app user }

  it "can create a new kid" do
    click_link 'Your Kids'
    click_link 'Add Kid'
    visit new_kid_path
    fill_in 'First name', with: 'Jackie'
    fill_in 'Last name', with: 'Smith'
    find('#kid_birthdate_1i').find(:xpath, 'option[2]').select_option
    find('#kid_birthdate_2i').find(:xpath, 'option[2]').select_option
    find('#kid_birthdate_3i').find(:xpath, 'option[2]').select_option
    find('#kid_gender').find(:xpath, 'option[2]').select_option

    expect{ click_button 'Save' }.to change{ Kid.count }.by(1)
  end
end
