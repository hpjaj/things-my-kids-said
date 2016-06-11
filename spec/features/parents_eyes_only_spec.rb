require 'rails_helper'

describe 'Making a quote parents eyes only' do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:parent) { create :user, first_name: 'Tom' }
  let!(:kid)   { create :kid, users: [parent] }
  let(:family) { create :user, first_name: 'Pam' }

  context "happy path" do
    context "creating a quote marked 'parents eyes only'" do
      before { sign_into_app parent }

      it "with one kid, a parent should see the 'parents eyes only' checkbox" do
        click_link '+ Create A Quote'

        expect(page).to have_content 'Parents eyes only'
      end

      it "parent can set 'parents eyes only'" do
        click_link '+ Create A Quote'
        find('#post_kids_age').find(:xpath, 'option[2]').select_option
        fill_in 'Quote', with: 'you go baffroom?'
        page.check('post_parents_eyes_only')
        click_button 'Save'

        expect(Post.first.parents_eyes_only).to be true
      end

      it "parent should see 'parents eyes only' quotes" do
        create :post, user_id: parent.id, kid_id: kid.id, parents_eyes_only: true, body: 'Hi mom'
        create :post, user_id: parent.id, kid_id: kid.id, parents_eyes_only: false, body: 'I did not'

        visit home_path

        expect(page).to have_content 'Hi mom'
        expect(page).to have_content 'I did not'

        visit kid_posts_path(kid.id)

        expect(page).to have_content 'Hi mom'
        expect(page).to have_content 'I did not'
      end
    end

    context "'parents eyes only' quote already exists" do
      before do
        family.following << kid
        create :post, user_id: parent.id, kid_id: kid.id, parents_eyes_only: true, body: 'Hi mom'
        create :post, user_id: parent.id, kid_id: kid.id, parents_eyes_only: false, body: 'I did not'
        expect(Post.count).to eq 2
        expect(Post.first.parents_eyes_only).to be true
        expect(Post.last.parents_eyes_only).to be false
        sign_into_app family
      end

      it "friend/family member should not see 'parents eyes only' quotes" do
        visit home_path

        expect(page).to have_content 'I did not'
        expect(page).to_not have_content 'Hi mom'

        visit kid_posts_path(kid.id)

        expect(page).to have_content 'I did not'
        expect(page).to_not have_content 'Hi mom'
      end
    end
  end
end
