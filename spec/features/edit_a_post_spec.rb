require 'rails_helper'

describe 'Editing a new post' do

  include Warden::Test::Helpers
  Warden.test_mode!

  context "happy path" do
    let(:user)   { create :user }
    let(:kid)    { create :kid, users: [user] }
    let!(:quote)  { create :post, user: user, kid: kid }
    let!(:kid_2) { create :kid, users: [user], first_name: 'Jackie' }

    before { sign_into_app user }

    it "can edit a post" do
      visit edit_post_path(quote)
      fill_in 'Quote', with: 'new and improved'
      page.select(kid_2.first_name, :from => "post_kid_id")
      click_button 'Save'

      quote.reload

      expect(quote.body).to eq 'new and improved'
      expect(quote.kid).to eq kid_2
    end
  end
end
