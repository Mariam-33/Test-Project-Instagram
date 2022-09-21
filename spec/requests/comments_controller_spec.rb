# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'devise'

RSpec.describe CommentsController, type: :request do
  let!(:photo) { create(:photo) }
  let!(:user) { create(:user) }
  let(:unauth_user) { User.create(username: Faker::Name.name, email: Faker::Internet.email, password: 'test321') }
  let!(:post2) { Post.create(id: 1, description: Faker::Lorem.sentence, user_id: user.id) }
  let(:comment) { Comment.create(id: 1, statement: Faker::Lorem.sentence, post_id: post2.id, user_id: post2.user.id) }
  before(:each) do
    sign_in user
    unauth_user.confirm
  end
  describe 'Comments/create' do
    it 'Create comments if user authorized and signed in' do
      post post_comments_path(post2.id), params: {
        comment: { user_id: comment.user.id, post_id: post2.id, statement: comment.statement },
        format: :js
      }
      expect(response.content_type).to eq('text/javascript')
    end
    it 'Cannot create comments if user is not signed in' do
      sign_out user
      post post_comments_path(post2.id), params: {
        comment: { user_id: user.id, post_id: post2.id, statement: comment.statement },
        format: :js
      }
      expect(response.body).to eql('You need to sign in or sign up before continuing.')
    end
    it 'Cannot create comments if user is not authorized' do
      sign_out user
      sign_in unauth_user
      post post_comments_path(post2.id), params: {
        comment: { user_id: unauth_user.id, post_id: post2.id, statement: comment.statement },
        format: :js
      }
      follow_redirect!
      expect(response.body).to include('You are not authorized to perform this action')
    end
    it 'Cannot create comments if content is not valid' do
      post post_comments_path(post2.id), params: {
        comment: { user_id: user.id, post_id: post2.id, statement: 'Hi' },
        format: :js
      }
      expect(flash[:alert]).to eql(['Statement is too short (minimum is 5 characters)'])
    end
  end

  describe 'Comments/update' do
    it 'Authorized and Signed in user can update comment' do
      patch "/posts/#{post2.id}/comments/#{comment.id}",
            params: { comment: { statement: 'Hellloo', user_id: user.id }, format: :js }
      expect(response.content_type).to eq('text/javascript')
    end
    it 'Cannot update comments if user is not authorized' do
      sign_out user
      sign_in unauth_user
      patch "/posts/#{post2.id}/comments/#{comment.id}", params: {
        comment: { user_id: unauth_user.id, statement: 'Hello everybody' },
        format: :js
      }
      follow_redirect!
      expect(response.body).to include('You are not authorized to perform this action')
    end
    it 'Cannot update comments if user is signed out' do
      sign_out user
      patch "/posts/#{post2.id}/comments/#{comment.id}", params: {
        comment: { user_id: user.id, statement: 'Hello everybody' },
        format: :js
      }
      expect(response.body).to eql('You need to sign in or sign up before continuing.')
    end
    it 'Cannot update comments if params are incorrect' do
      patch "/posts/#{post2.id}/comments/#{comment.id}",
            params: { comment: { statement: 'Hi', user_id: user.id }, format: :js }
      expect(response.body).to include('Something went wrong')
    end
  end

  describe 'Posts/edit' do
    it 'Signed in and comment owner can edit' do
      get edit_post_comment_path(comment.post.id, comment.id), params: { format: :js }
      expect(response.content_type).to eq('text/javascript')
    end

    it 'Signed out user cannot edit' do
      sign_out user
      get edit_post_comment_path(comment.post.id, comment.id)

      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end
  describe 'Comments/destroy' do
    it 'Authorized and Signed in user can destroy comment' do
      delete "/posts/#{post2.id}/comments/#{comment.id}", params: { comment: { user_id: user.id }, format: :js }
      expect(response.content_type).to eq('text/javascript')
    end
    it 'Cannot destroy comments if user is not authorized' do
      sign_out user
      sign_in unauth_user
      delete "/posts/#{post2.id}/comments/#{comment.id}", params: { comment: { user_id: unauth_user.id }, format: :js }
      follow_redirect!
      expect(response.body).to include('You are not authorized to perform this action')
    end
    it 'Cannot destroy comments if user is signed out' do
      sign_out user
      delete "/posts/#{post2.id}/comments/#{comment.id}", params: { comment: { user_id: user.id }, format: :js }
      expect(response.body).to eql('You need to sign in or sign up before continuing.')
    end
    it 'Cannot destroy comments if action returns false' do
      allow(Comment).to receive(:find).and_return(comment)
      allow(comment).to receive(:destroy).and_return(false)
      delete "/posts/#{post2.id}/comments/#{comment.id}", params: { comment: { user_id: nil }, format: :js }
      expect(response.body).to include('Comment not destroyed')
    end
  end
end
