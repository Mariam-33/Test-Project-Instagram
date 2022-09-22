# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { create(:user) }
  context 'Associations' do
    it { is_expected.to belong_to(:follower) }
    it { is_expected.to belong_to(:followed) }
  end
  context 'validations' do
    it {
      rel = build(:relationship)
      User.create(id: rel.followed_id, username: 'Followed', email: 'follower@gmail.com', password: 'follower')
      rel.save
      is_expected.to validate_uniqueness_of(:follower_id).case_insensitive.scoped_to(:followed_id)
    }
  end
  context 'Callbacks' do
    it {
      is_expected.to callback(:accept_request).before(:create)
    }
  end
end
