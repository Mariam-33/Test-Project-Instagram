# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { create(:user) }
  describe 'Testing Associations' do
    context 'Associations' do
      it { is_expected.to belong_to(:follower) }
      it { is_expected.to belong_to(:followed) }
    end
  end
  describe 'Testing Validations' do
    context 'validations' do
      it {
        rel = build(:relationship)
        User.create(id: rel.followed_id, username: 'Followed', email: Faker::Internet.email,
                    password: Faker::Alphanumeric.alphanumeric(number: 8))
        rel.save
        is_expected.to validate_uniqueness_of(:follower_id).scoped_to(:followed_id)
      }
    end
  end
  describe 'Testing Callbacks' do
    context 'Callbacks' do
      it {
        is_expected.to callback(:accept_request).before(:create)
      }
    end
  end
end
