require 'rails_helper'

RSpec.describe FriendAndFamily, type: :model do
  describe "##parents_kids_friends_and_family" do
    let(:dad)      { create :user }
    let(:mom)      { create :user }
    let(:son)      { create :kid, :users => [dad] }
    let(:daughter) { create :kid, :users => [dad] }
    let!(:friend)  { create :user }

    before do
      mom.kids << [son, daughter]
      son.followers << friend
      daughter.followers << friend
      expect(mom.kids).to include(son, daughter)
      expect(dad.kids).to include(son, daughter)
      expect(son.followers).to eq [friend]
    end

    let(:results) { FriendAndFamily.parents_kids_friends_and_family(dad) }

    it "returns the FriendAndFamily's that are following all of the parent's kids" do
      expect(results).to include(FriendAndFamily.first, FriendAndFamily.second)
    end
  end
end
