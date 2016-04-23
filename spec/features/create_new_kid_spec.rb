require 'rails_helper'

describe 'Creating a new kid' do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user }

  before { sign_into_app user }

  it "can create a new kid" do
    click_link 'New Kid'
    fill_in 'Name', with: 'Jackie'
    page.select("2012", :from => "kid_birthdate_1i")
    page.select("September", :from => "kid_birthdate_2i")
    page.select("1", :from => "kid_birthdate_3i")

    expect{ click_button 'Save' }.to change{ Kid.count }.by(1)
  end
end
