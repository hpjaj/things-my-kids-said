require 'rails_helper'

RSpec.describe KidsController, type: :controller do
  include Devise::TestHelpers

  render_views

  let(:mom) { create :user, first_name: 'Susan' }

  describe "POST :create" do
    let(:user)  { create :user }
    let(:attrs) { { first_name: 'Jackie', last_name: 'Smith', birthdate: '2010-04-16', gender: 'female', created_by: user.id.to_s } }

    before do
      sign_in user
      post :create, kid: attrs
    end

    it "creates associations between the user and the user's kid" do
      expect(user.kids.count).to eq 1
      expect(Kid.first.users.to_a).to eq [user]
    end

    it "creates a kid with the correct attributes" do
      expect(Kid.first.birthdate).to eq attrs[:birthdate].to_date
      expect(Kid.first.gender).to eq attrs[:gender]
    end

    it "downcases the kid's first and last name for Kid#cannot_create_duplicate validation" do
      expect(Kid.first.first_name).to eq attrs[:first_name].downcase
      expect(Kid.first.last_name).to eq attrs[:last_name].downcase
    end

    it "sets the Kid's #created_by to the user's id" do
      expect(Kid.first.created_by).to eq user.id
    end

    context "fellow parent creating duplicate of their own kid" do
      let(:attrs) { { first_name: 'Jackie', last_name: 'Smith', birthdate: '2010-04-16', gender: 'female', created_by: mom.id.to_s } }

      before { mom.kids << Kid.first }

      it "will raise an error when a parent tries to create a kid that already exists underneath the set of parents" do
        post :create, kid: attrs

        expect(response.body).to have_content('A kid with the same first name, last name, birthdate and gender has already been created by your spouse/partner.')
      end

      it "will raise an error when a parent tries to create a kid that already exists, with the names in a different case, underneath the set of parents" do
        post :create, kid: { gender: 'female', birthdate: '2010-04-16', first_name: 'jackie', last_name: 'smith', created_by: mom.id.to_s }

        expect(response.body).to have_content('A kid with the same first name, last name, birthdate and gender has already been created by your spouse/partner.')
      end
    end
  end

  describe "PATCH :update" do
    let(:date) { Date.new(2012, 1, 15) }
    let(:dad)  { create :user, first_name: 'Tom' }
    let!(:son) { create :kid, users: [dad, mom], gender: Kid::BOY, birthdate: date, first_name: 'Jack', last_name: 'Johnson', created_by: dad.id }

    before do
      sign_in mom
      expect(Kid.count).to eq 1
      expect(son.parents).to include(mom, dad)
      patch :update, id: son.id.to_s, kid: { first_name: 'Jack', last_name: 'Johnson', birthdate: date + 1.month, gender: Kid::BOY, created_by: dad.id }
      son.reload
    end

    it "updates the kid record accordingly" do
      expect(son.birthdate).to eq(date + 1.month)
    end

    it "downcases the kid's first and last name" do
      expect(son.first_name).to eq 'jack'
      expect(son.last_name).to eq 'johnson'
    end
  end
end
