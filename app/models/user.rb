# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :followers, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy,
                       inverse_of: :followed
  has_many :following, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy,
                       inverse_of: :follower
  attr_accessor :image

  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable
  validates :username, presence: true, format: { with: /\A(?=.*[a-z])[a-z\d]+\Z/i },
                       uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 150 }
  validates :email, presence: true
  validates :account, presence: true
  validates :bio, length: { maximum: 250 }

  enum account: { Public: 0, Private: 1 }

  scope :search_by_username, ->(keyword) { where('username ILIKE ?', "%#{keyword}%") }
end
