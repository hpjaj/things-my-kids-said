require 'rails_helper'

RSpec.describe ParentsController, type: :controller do
  include Devise::TestHelpers
  render_views

  let(:parent) { create :user, first_name: 'Susan' }
  let(:spouse) { create :user, first_name: 'Tom' }
  let!(:kid)   { create :kid, users: [parent, spouse] }

  before do
    sign_in parent
    expect(kid.parents).to include(parent, spouse)
  end

  describe "DELETE :destroy" do
    it "successfully deletes a parent permission" do
      delete :destroy, id: "#{spouse.id}/#{kid.id}"

      expect(kid.parents.count).to eq 1
      expect(kid.parents.first).to eq parent
    end
  end

end
