require 'rails_helper'

describe "Displays a kid's age when creating a quote" do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user)      { create :user }
  let!(:kid)      { create :kid, users: [user], birthdate: birth_day.strftime("%Y-%m-%d") }
  let!(:post)     { create :post, users: [user], kids: [kid] }
  let(:birth_day) { 18.months.ago }

  before do
    sign_into_app user
  end

  context "displays the kid's age based on when the quote was created" do
    context "kid is under 2 years old" do
      it "displays their age in months" do
        visit post_path(post.id)

        expect(page).to have_content "When #{kid.name} was 18 months old"
      end
    end

    context "kid is between 2 - 9 years old" do
      let(:birth_day) { 38.months.ago }

      it "displays their age in years and months" do
        visit post_path(post.id)

        expect(page).to have_content "When #{kid.name} was 3 years 2 months old"
      end
    end

    context "kid is 10+ years old" do
      let(:birth_day) { 11.years.ago }

      it "displays their age in years" do
        visit post_path(post.id)

        expect(page).to have_content "When #{kid.name} was 11 years old"
      end
    end
  end
end
