require 'rails_helper'

describe 'Creating a new post' do

  include Warden::Test::Helpers
  Warden.test_mode!

  context "happy path" do
    let(:user) { create :user }
    let!(:kid) { create :kid, users: [user] }

    before { sign_into_app user }

    it "can create a new post" do
      click_link 'New Quote'
      fill_in 'Quote', with: 'you go baffroom?'

      expect{ click_button 'Save' }.to change{ Post.count }.by(1)
    end

    context "user has one kid" do
      before { visit new_post_path }

      it "displays the kids name" do
        expect(page).to have_content "Kid: #{kid.name}"
      end

      it "sets the kid as the default for the post" do
        fill_in 'Quote', with: 'you go baffroom?'
        click_button 'Save'

        expect(Post.first.kids).to eq [kid]
      end
    end

    context "user has more than one kid" do
      let!(:kid_2) { create :kid, users: [user] }

      before { visit new_post_path }

      it "displays all kids names" do
        expect(page).to have_content kid.name
        expect(page).to have_content kid_2.name
      end

      it "let's you pick more than one kid" do
        find(:css, "#post_kid_ids_#{kid.id}").set(true)
        find(:css, "#post_kid_ids_#{kid_2.id}").set(true)
        fill_in 'Quote', with: 'you go baffroom?'
        click_button 'Save'

        expect(Post.first.kids).to eq [kid, kid_2]
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

      it "promps you to create a kid when creating a Post" do
        expect(page).to have_content "Create Your Kid"
      end

      it "clicking 'Create Your Kid' link redirects to New Kid page" do
        click_link 'Create Your Kid'

        expect(current_path).to eq new_kid_path
      end
    end
  end
end
