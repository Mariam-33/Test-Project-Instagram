# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Testing Associations' do
    context 'Associations' do
      it { is_expected.to have_many(:posts).dependent(:destroy) }
      it { is_expected.to have_many(:comments).dependent(:destroy) }
      it { is_expected.to have_many(:likes).dependent(:destroy) }
      it { is_expected.to have_many(:followers).class_name(:Relationship).dependent(:destroy) }
      it { is_expected.to have_many(:following).class_name(:Relationship).dependent(:destroy) }
      it { is_expected.to have_many(:stories).dependent(:destroy) }
    end
  end
  describe 'Testing Validations' do
    context 'validations' do
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_length_of(:username).is_at_least(3) }
      it { is_expected.to validate_length_of(:username).is_at_most(150) }
      it { is_expected.to validate_uniqueness_of(:username).ignoring_case_sensitivity }
      it { is_expected.to validate_presence_of(:account) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_length_of(:bio).is_at_most(250) }
    end
    context 'Positive validation for format matching' do
      it 'Username is valid' do
        user = build(:user, :valid_username)
        expect(user.save).to eq(true)
      end
    end
    context 'Negative validation for format matching' do
      it 'Username is Invalid' do
        user = build(:user, :invalid_username)
        expect(user.save).to eq(false)
      end
    end
  end
  describe 'Testing Enum' do
    context 'Enum' do
      it do
        should define_enum_for(:account)
          .with_values(Public: 0, Private: 1)
      end
    end
  end
  describe 'Testing Scopes' do
    context 'Scope' do
      it 'returns the matching users list' do
        expect(User.search_by_username('TestUser').pluck(:id).first.eql?(1))
      end
    end
  end
end
