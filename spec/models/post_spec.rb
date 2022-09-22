# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:photo) { create(:photo) }
  context 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:photos).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
  end
  context 'validations' do
    it { is_expected.to validate_length_of(:description).is_at_least(0) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it 'validates presence of photos' do
      post = build(:post)
      post.save
      expect(post.photos.count >= 1).to eq(true)
    end
  end
  it 'validates absence of photos' do
    post = build(:post, :invalid_post)
    post.save
    expect(post.photos.count.nil?).to eq(false)
  end
  describe 'Post is liked' do
    it 'finds whether a post is liked or not' do
      post = build(:post)
      post.save
      expect(post.liked?(post.user)).equal?(:like)
    end
  end
end
