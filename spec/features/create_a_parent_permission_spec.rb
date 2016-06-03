require 'rails_helper'

describe 'Create a parent permission' do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:parent)  { create :user, first_name: 'Susan' }
  let!(:spouse) { create :user, first_name: 'Tom' }
  let!(:kid)    { create :kid, users: [parent] }

  before do
    sign_into_app parent
    click_link 'Manage Parents'
    expect(current_path).to eq parents_path
    click_link 'Add New Parent'
    find('#parents_kid_id').find(:xpath, 'option[2]').select_option
    find('#parents_parent_id').find(:xpath, 'option[2]').select_option
    click_button 'Save'
    kid.reload
  end

  it "successfully allows a parent to create a new parent" do
    expect(current_path).to eq parents_path
    expect(kid.parents).to include(parent, spouse)
  end

  it "the Parent :index displays the both parent kid permissions" do
    expect(page).to have_content spouse.full_name
    expect(page).to have_content parent.full_name
    expect(page).to have_content kid.full_name
  end

end
