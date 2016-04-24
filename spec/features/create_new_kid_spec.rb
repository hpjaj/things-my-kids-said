require 'rails_helper'

describe 'Creating a new kid', js: true do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user }

  before { sign_into_app user }

  it "can create a new kid" do
    click_link 'New Kid'
    fill_in 'Name', with: 'Jackie'
    page.execute_script("$('#kid_birthdate').val('21/02/2010')")

    expect{ click_button 'Save' }.to change{ Kid.count }.by(1)
  end
end
