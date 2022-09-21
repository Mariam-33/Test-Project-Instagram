# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'devise'

RSpec.describe PostsController, type: :request do
  let!(:photo) { create(:photo) }
  let(:unauth_user) { User.create(username: Faker::Name.name, email: Faker::Internet.email, password: 'test321') }
  let!(:post1) { create(:post) }
  let(:user) { post1.user }

  before(:each) do
    unauth_user.confirm
    sign_in user
  end
  describe 'Posts/new' do
    it 'Signed in user should be able to create post' do
      get new_post_path
      expect(response).to have_http_status(200)
    end
    it 'Signed out user cannot create post' do
      sign_out user
      get new_post_path
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  describe 'Posts/show' do
    it 'Authorized and signed in user can see post' do
      get post_path(post1.id)

      expect(response).to have_http_status(200)
    end

    it 'Unauthorized user cannot see post' do
      sign_out user
      sign_in unauth_user
      get post_path(post1.id)
      follow_redirect!
      expect(response.body).to include('You are not authorized to perform this action')
    end
    it 'Signed out user cannot see post' do
      sign_out user
      get post_path(post1.id)
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  describe 'Posts/create' do
    it 'Post should be created with right params i.e. images' do
      post posts_path,
           params: { id: 5, user_id: user.id, description: post1.description,
                     images: [fixture_file_upload(Rails.root.join('spec/fixtures/xabout.png'), 'image/png')] }
      follow_redirect!

      expect(flash[:notice]).to eql('Post created successfully')
    end

    it 'Post should be not created without right params i.e. images' do
      post posts_path, params: { id: 6, user_id: user.id, description: post1.description,
                                 images: nil }

      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eql(['Please attach images within range of 1-10 per post'])
    end

    it 'Signed out user cannot create post' do
      sign_out user
      post posts_path, params: { id: 6, user_id: user.id, description: post1.description,
                                 images: nil }
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  describe 'Post/destroy' do
    it 'Post owner can delete post if signed in' do
      delete "/posts/#{post1.id}", params: { user_id: user.id }

      follow_redirect!
      expect(flash[:notice]).to eql('Post is destroyed successfully')
    end

    it 'Delete cannot happen if action fails' do
      allow(Post).to receive(:find).and_return(post1)
      allow(post1).to receive(:destroy).and_return(false)
      delete "/posts/#{post1.id}"
      follow_redirect!
      expect(response.body).to include('Something went wrong')
    end

    it 'Unauthorized user cannot delete post' do
      sign_out user
      sign_in unauth_user
      delete "/posts/#{post1.id}", params: { user_id: unauth_user.id }

      follow_redirect!
      expect(response.body).to include('You are not authorized to perform this action')
    end

    it 'Signed out user cannot delete post' do
      sign_out user
      delete "/posts/#{post1.id}"

      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  describe 'Posts/index' do
    it 'Authorized user can see all posts' do
      get posts_path, params: { user_id: user.id }

      expect(response).to have_http_status(200)
    end

    it 'Signed out user cannot see post' do
      sign_out user
      get posts_path(unauth_user.id)
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  describe 'Posts/edit' do
    it 'Signed in and post owner can edit' do
      get edit_post_path(post1.id)

      expect(response).to have_http_status(200)
    end

    it 'Signed out user cannot edit' do
      sign_out user
      get edit_post_path(post1.id)

      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  describe 'Posts/update' do
    it 'Signed in and post owner can update post with right params' do
      put "/posts/#{post1.id}",
          params: { user_id: user.id, description: post1.description,
                    images: [fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'), 'image/png')] }
      follow_redirect!

      expect(flash[:notice]).to eql('Post updated successfully')
    end

    it 'Unauthorized user cannot update post' do
      sign_out user
      sign_in unauth_user
      put "/posts/#{post1.id}",
          params: { user_id: user.id, description: post1.description,
                    images: [fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'), 'image/png')] }
      follow_redirect!
      expect(response.body).to include('You are not authorized to perform this action')
    end

    it 'should not update post as signed in user is not creator of post' do
      put "/posts/#{post1.id}", params: { user_id: user.id, description: post1.description,
                                          images: [
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png'),
                                            fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'),
                                                                'image/png')
                                          ] }
      follow_redirect!
      expect(flash[:alert]).to eql(['Please attach images within range of 1-10 per post'])
    end
  end
end
