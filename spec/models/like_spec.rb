# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Like, type: :model do
  describe 'Testing Associations' do
    context 'Model Associations' do
      it { is_expected.to belong_to(:user) }
      it { is_expected.to belong_to(:post) }
    end
  end
  describe 'Testing validations' do
    context 'validations' do
      let!(:photo) { create(:photo) }
      subject { build(:like) }
      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:post_id) }
    end
  end
end
