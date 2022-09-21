# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Like, type: :model do
  let!(:photo) { create(:photo) }
  let!(:user) { create(:user) }
  context 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  context 'validations' do
    subject { build(:like) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:post_id) }
  end
end
