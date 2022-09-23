# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:photo) { create(:photo) }
  describe 'Testing Associations' do
    context 'Model Associations' do
      it { is_expected.to belong_to(:user) }
      it { is_expected.to have_many(:photos).dependent(:destroy) }
      it { is_expected.to have_many(:comments).dependent(:destroy) }
      it { is_expected.to have_many(:likes).dependent(:destroy) }
    end
  end
  describe 'Testing validations' do
    context 'validations' do
      it { is_expected.to validate_length_of(:description).is_at_most(500) }
    end
    context 'Positive validations' do
      it 'validates presence of photos' do
        post = build(:post)
        post.save
        expect(!post.photos.nil?).to eq(true)
      end
    end
    context 'Negative validations' do
      it 'validates absence of photos' do
        post = build(:post, :invalid_post)
        post.save
        expect(post.photos.nil?).to eq(false)
      end
    end
  end
  describe 'Post is liked' do
    context 'Model function' do
      it 'finds whether a post is liked or not' do
        post = create(:post)
        expect(post.liked?(post.user)).equal?(:like)
      end
    end
  end
end
