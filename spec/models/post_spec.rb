require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:kid_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:date_said) }
  end

  describe "##all_associated_kids_posts" do
    let(:mom) { create :user }
    let(:dad) { create :user }
    let(:daughter) { create :kid, users: [mom, dad] }
    let(:aunt) { create :user }
    let(:nephew) { create :kid, users: [aunt] }

    let(:some_guy) { create :user }
    let(:some_kid) { create :kid, users: [some_guy] }
    let!(:some_post) { create :post, user: some_guy, kid: some_kid }

    before do
      dad.following << nephew
      mom.following << nephew
      aunt.following << daughter
    end

    context "Posts created by me"do
      context "about my kid" do
        let!(:family_post) { create :post, user: dad, kid: daughter }
        let!(:parents_post) { create :post, :for_parents, user: dad, kid: daughter }
        let!(:public_post) { create :post, :for_public, user: dad, kid: daughter }
        let!(:my_post) { create :post, :for_me, user: dad, kid: daughter }
        let(:results) { Post.all_associated_kids_posts(dad) }

        it "returns posts with visibility set to friends and family" do
          expect(results).to include family_post
        end

        it "returns posts with visibility set to parents" do
          expect(results).to include parents_post
        end

        it "returns posts with visibility set to public" do
          expect(results).to include public_post
        end

        it "returns posts with visibility set to me" do
          expect(results).to include my_post
        end

        it "sorts the results by Post#updated_at DESC" do
          expect(results).to match_array([family_post, parents_post, public_post, my_post])
        end

        it "does not include a post about a kid not in my circles" do
          expect(Post.count).to eq 5
          expect(results.size).to eq 4
          expect(results).to_not include some_post
        end
      end

      context "about a friend and family member's kid" do
        let!(:family_post) { create :post, user: dad, kid: nephew }
        let!(:my_post) { create :post, :for_me, user: dad, kid: nephew }
        let(:results) { Post.all_associated_kids_posts(dad) }

        it "returns posts with visibility set to friends and family" do
          expect(results).to include family_post
        end

        it "returns posts with visibility set to me" do
          expect(results).to include my_post
        end

        it "does not include a post about a kid not in my circles" do
          expect(Post.count).to eq 3
          expect(results.size).to eq 2
          expect(results).to_not include some_post
        end
      end
    end

    context "Post created by a spouse" do
      context "about my kid" do
        let!(:family_post) { create :post, user: mom, kid: daughter }
        let!(:parents_post) { create :post, :for_parents, user: mom, kid: daughter }
        let!(:public_post) { create :post, :for_public, user: mom, kid: daughter }
        let!(:my_post) { create :post, :for_me, user: mom, kid: daughter }
        let(:results) { Post.all_associated_kids_posts(dad) }

        it "returns posts with visibility set to friends and family" do
          expect(results).to include family_post
        end

        it "returns posts with visibility set to parents" do
          expect(results).to include parents_post
        end

        it "returns posts with visibility set to public" do
          expect(results).to include public_post
        end

        it "does not return posts with visibility set to me" do
          expect(results).to_not include my_post
        end

        it "does not include a post about a kid not in my circles" do
          expect(Post.count).to eq 5
          expect(results.size).to eq 3
          expect(results).to_not include some_post
        end
      end

      context "about a friend and family member's kid" do
        let!(:family_post) { create :post, user: mom, kid: nephew }
        let!(:my_post) { create :post, :for_me, user: mom, kid: nephew }
        let(:results) { Post.all_associated_kids_posts(dad) }

        it "returns posts with visibility set to friends and family" do
          expect(results).to include family_post
        end

        it "does not return posts with visibility set to me" do
          expect(results).to_not include my_post
        end

        it "does not include a post about a kid not in my circles" do
          expect(Post.count).to eq 3
          expect(results.size).to eq 1
          expect(results).to_not include some_post
        end
      end
    end

    context "Post created by a friend or family member" do
      context "about my kid" do
        let!(:family_post) { create :post, user: aunt, kid: daughter }
        let!(:my_post) { create :post, :for_me, user: aunt, kid: daughter }
        let(:results) { Post.all_associated_kids_posts(dad) }

        it "returns posts with visibility set to friends and family" do
          expect(results).to include family_post
        end

        it "does not return posts with visibility set to me" do
          expect(results).to_not include my_post
        end

        it "does not include a post about a kid not in my circles" do
          expect(Post.count).to eq 3
          expect(results.size).to eq 1
          expect(results).to_not include some_post
        end
      end

      context "about a friend or family member's kid" do
        let!(:family_post) { create :post, user: aunt, kid: nephew }
        let!(:parents_post) { create :post, :for_parents, user: aunt, kid: nephew }
        let!(:public_post) { create :post, :for_public, user: aunt, kid: nephew }
        let!(:my_post) { create :post, :for_me, user: aunt, kid: nephew }
        let(:results) { Post.all_associated_kids_posts(dad) }

        it "returns posts with visibility set to friends and family" do
          expect(results).to include family_post
        end

        it "returns posts with visibility set to public" do
          expect(results).to include public_post
        end

        it "does not return posts with visibility set to parents" do
          expect(results).to_not include parents_post
        end

        it "does not return posts with visibility set to me" do
          expect(results).to_not include my_post
        end

        it "does not include a post about a kid not in my circles" do
          expect(Post.count).to eq 5
          expect(results.size).to eq 2
          expect(results).to_not include some_post
        end
      end
    end
  end
end
