# frozen_string_literal: true

FactoryBot.define do
  factory :photo do
    id { 1 }
    image { fixture_file_upload(Rails.root.join('spec/fixtures/xabout.png'), 'image/png') }
    photoable_type { 'Post' }
    photoable_id { 1 }
    photoable { Post.create(id: 1, description: 'Life is good', user_id: 5) }
  end
  trait :story_photo do
    photoable_type { 'Story' }
    photoable { Story.create(id: 1, content: 'Life is good', user_id: 5) }
  end
  trait :invalid_image do
    image { fixture_file_upload(Rails.root.join('spec/fixtures/test.txt'), 'image/text') }
  end
end
