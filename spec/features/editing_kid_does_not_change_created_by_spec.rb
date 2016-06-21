require 'rails_helper'

describe 'Editing a kid does not change their original :created_by' do

  include Warden::Test::Helpers
  Warden.test_mode!

  context "happy path" do
    let(:date) { Date.new(2012, 1, 15) }
    let(:dad)  { create :user, first_name: 'Tom' }
    let(:mom)  { create :user, first_name: 'Susan' }
    let!(:son) { create :kid, users: [dad, mom], gender: Kid::BOY, birthdate: date, first_name: 'Jack', last_name: 'Johnson', created_by: dad.id }

    before do
      sign_into_app mom
      expect(Kid.count).to eq 1
      expect(son.parents).to include(mom, dad)
    end

    it "editing kid does not alter their original :created_by" do
      expect(son.created_by).to eq dad.id

      visit edit_kid_path(son)
      fill_in 'First name', with: 'Drew'
      click_button 'Save'
      son.reload

      expect(son.first_name).to eq 'drew'
      expect(son.last_name).to eq 'johnson'
      expect(son.created_by).to eq dad.id
    end
  end
end
