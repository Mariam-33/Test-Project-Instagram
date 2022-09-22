# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Testing Associations' do
    context 'Model Associations' do
      it { is_expected.to belong_to(:user) }
      it { is_expected.to belong_to(:post) }
    end
  end
  describe 'Testing validations' do
    let!(:photo) { create(:photo) }
    context 'validations' do
      it { is_expected.to validate_presence_of(:statement) }
      it { is_expected.to validate_length_of(:statement).is_at_least(5) }
      it { is_expected.to validate_length_of(:statement).is_at_most(500) }
      context 'Positive validations' do
        it 'valid length of comment' do
          comment = build(:comment)
          expect(comment.save).to eq(true)
        end
      end
      context 'Negative validations' do
        it 'Invalid length of comment' do
          comment = build(:comment, :invalid_text)
          expect(comment.save).to eq(false)
        end
      end
    end
  end
end
