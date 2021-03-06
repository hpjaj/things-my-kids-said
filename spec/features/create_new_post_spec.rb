require 'rails_helper'

describe 'Creating a new post' do

  include Warden::Test::Helpers
  Warden.test_mode!

  context "happy path" do
    let(:user) { create :user }
    let!(:kid) { create :kid, users: [user] }

    before { sign_into_app user }

    it "can create a new post" do
      click_link '+ Add Quote'
      find('#post_kids_age').find(:xpath, 'option[2]').select_option
      fill_in 'Quote', with: 'you go baffroom?'
      find('#post_visible_to').find(:xpath, 'option[1]').select_option

      expect{ click_button 'Save' }.to change{ Post.count }.by(1)
    end

    context "user has one kid" do
      before { visit new_post_path }

      it "displays the kids name" do
        expect(page).to have_content "Kid: #{kid.first_name}"
      end

      it "sets the kid as the default for the post" do
        find('#post_kids_age').find(:xpath, 'option[2]').select_option
        fill_in 'Quote', with: 'you go baffroom?'
        find('#post_visible_to').find(:xpath, 'option[1]').select_option
        click_button 'Save'

        expect(Post.first.kid).to eq kid
      end
    end

    context "user has more than one kid" do
      let!(:kid_2) { create :kid, users: [user], first_name: 'Jackie' }

      before { visit new_post_path }

      it "displays all kids names" do
        expect(page).to have_content kid.first_name
        expect(page).to have_content kid_2.first_name
      end

      it "let's you pick one kid" do
        page.select(kid.first_name, :from => "post_kid_id")
        find('#post_kids_age').find(:xpath, 'option[2]').select_option
        fill_in 'Quote', with: 'you go baffroom?'
        find('#post_visible_to').find(:xpath, 'option[1]').select_option
        click_button 'Save'

        expect(Post.first.kid).to eq kid
      end
    end
  end

  context "edge cases" do
    context "with no kids" do
      let(:user) { create :user }

      before do
        sign_into_app user
        visit new_post_path
      end

      it "redirects you to the help page" do
        expect(current_path).to eq(help_path)
      end

      it "clicking the 'Home' link redirects to the help page" do
        click_link "Home"

        expect(current_path).to eq(help_path)
      end

      it "clicking the 'Add quote' link redirects to the help page" do
        click_link "+ Add Quote"

        expect(current_path).to eq(help_path)
      end

      it "clicking 'Add Kid' link redirects to New Kid page" do
        click_link 'Add Kid'

        expect(current_path).to eq new_kid_path
      end
    end

    context "with an empty form" do
      let(:user) { create :user }
      let!(:kid) { create :kid, users: [user] }

      before do
        sign_into_app user
        visit new_post_path
      end

      it "displays the error message when saving with invalid data" do
        click_button 'Save'

        expect(page).to have_content 'There was a problem saving your quote. Please try again.'
      end
    end
  end
end
