require 'rails_helper'

describe 'Creating a new post' do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user }

  before { sign_into_app user }

  it "can create a new post" do
    click_link 'New Quote'
    fill_in 'Quote', with: 'you go baffroom?'

    expect{ click_button 'Save' }.to change{ Post.count }.by(1)
  end

  it "displays the"
end
