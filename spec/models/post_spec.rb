require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "##all_associated_kids_posts" do
    let(:parent_1) { create :user }
    let(:kid_1)    { create :kid, users: [parent_1] }
    let(:parent_2) { create :user }
    let(:kid_2)    { create :kid, users: [parent_2] }
    let(:parent_3) { create :user }
    let(:kid_3)    { create :kid, users: [parent_3] }

    let!(:post_1)  { create :post, user: parent_1, kid: kid_1 }
    let!(:post_2)  { create :post, user: parent_2, kid: kid_2 }
    let!(:post_3)  { create :post, user: parent_3, kid: kid_3 }

    before do
      parent_1.following << kid_2
    end

    it "returns only Posts from the user's kids and kids the user is following" do
      results = Post.all_associated_kids_posts(parent_1)

      expect(Post.count).to eq 3
      expect(results.count).to eq 2
      expect(results).to contain_exactly(post_1, post_2)
    end

    it "sorts the results by Post#updated_at DESC" do
      results = Post.all_associated_kids_posts(parent_1)

      expect(results).to match_array([post_2, post_1])
    end
  end
end
