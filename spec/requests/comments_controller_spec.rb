# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'devise'

RSpec.describe CommentsController, type: :request do
  let!(:photo) { create(:photo) }
  let(:user) { create(:user) }
  let(:unauth_user) do
    User.create(username: Faker::Name.name, email: Faker::Internet.email,
                password: Faker::Alphanumeric.alphanumeric(number: 8))
  end
  let(:post2) { Post.create(id: 1, description: Faker::Lorem.sentence, user_id: user.id) }
  let(:comment) { Comment.create(id: 1, statement: Faker::Lorem.sentence, post_id: post2.id, user_id: post2.user.id) }
  before(:each) do
    sign_in user
    unauth_user.confirm
  end
  describe 'Comments/create' do
    context 'Allow comment creation' do
      it 'is allowed for authorized and signed in user to create comment' do
        post post_comments_path(post2.id), params: {
          comment: { user_id: comment.user.id, post_id: post2.id, statement: comment.statement },
          format: :js
        }
        expect(response.content_type).to eq('text/javascript')
      end
    end
    context 'Do not allow comment creation' do
      it 'is not allowed to create comment with wrong params' do
        post post_comments_path(post2.id), params: {
          comment: { user_id: user.id, post_id: post2.id, statement: 'Hi' },
          format: :js
        }
        expect(flash[:alert]).to eql(['Statement is too short (minimum is 5 characters)'])
      end
      context 'User has signed out' do
        before do
          sign_out user
        end
        it 'is not allowed for signed in user to create comment' do
          post post_comments_path(post2.id), params: {
            comment: { user_id: user.id, post_id: post2.id, statement: comment.statement },
            format: :js
          }
          expect(response.body).to eql('You need to sign in or sign up before continuing.')
        end
        it 'is not allowed for unauthorized user to create comment' do
          sign_in unauth_user
          post post_comments_path(post2.id), params: {
            comment: { user_id: unauth_user.id, post_id: post2.id, statement: comment.statement },
            format: :js
          }
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action')
        end
      end
    end
  end

  describe 'Comments/update' do
    context 'Allow comment updation' do
      it 'is allowed for signed in and authorized user to update comment' do
        patch "/posts/#{post2.id}/comments/#{comment.id}",
              params: { comment: { statement: 'Hellloo', user_id: user.id }, format: :js }
        expect(response.content_type).to eq('text/javascript')
      end
    end
    context 'Do not allow comment creation' do
      it 'is not allowed to update comment if params are incorrect' do
        patch "/posts/#{post2.id}/comments/#{comment.id}",
              params: { comment: { statement: 'Hi', user_id: user.id }, format: :js }
        expect(response.body).to include('Something went wrong')
      end
      context 'User has signed out' do
        before do
          sign_out user
        end
        it 'is not allowed for unauthorized user to update comment' do
          sign_in unauth_user
          patch "/posts/#{post2.id}/comments/#{comment.id}", params: {
            comment: { user_id: unauth_user.id, statement: 'Hello everybody' },
            format: :js
          }
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action')
        end
        it 'is not allowed to update comment if user has signed out' do
          patch "/posts/#{post2.id}/comments/#{comment.id}", params: {
            comment: { user_id: user.id, statement: 'Hello everybody' },
            format: :js
          }
          expect(response.body).to eql('You need to sign in or sign up before continuing.')
        end
      end
    end
  end

  describe 'Posts/edit' do
    context 'Allow comment edit' do
      it 'is allowed for authorized user to render edit comment' do
        get edit_post_comment_path(comment.post.id, comment.id), params: { format: :js }
        expect(response.content_type).to eq('text/javascript')
      end
    end
    context 'Do not Allow comment edit' do
      it 'is not allowed for signed out user to render edit comment' do
        sign_out user
        get edit_post_comment_path(comment.post.id, comment.id)
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end
  describe 'Comments/destroy' do
    context 'Allow comment deletion' do
      it 'is allowed for authorized and signed in user to delete comment' do
        delete "/posts/#{post2.id}/comments/#{comment.id}", params: { comment: { user_id: user.id }, format: :js }
        expect(response.content_type).to eq('text/javascript')
      end
    end
    context 'Do not allow comment deletion' do
      it 'is not allowed to delete comment if action return false' do
        allow(Comment).to receive(:find).and_return(comment)
        allow(comment).to receive(:destroy).and_return(false)
        delete "/posts/#{post2.id}/comments/#{comment.id}", params: { comment: { user_id: nil }, format: :js }
        expect(response.body).to include('Comment not destroyed')
      end
      context 'User has signed out' do
        before do
          sign_out user
        end
        it 'is not allowed for unauthorized user to delete comment' do
          sign_in unauth_user
          delete "/posts/#{post2.id}/comments/#{comment.id}",
                 params: { comment: { user_id: unauth_user.id }, format: :js }
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action')
        end
        it 'is not allowed to delete comment if user has signed out' do
          delete "/posts/#{post2.id}/comments/#{comment.id}", params: { comment: { user_id: user.id }, format: :js }
          expect(response.body).to eql('You need to sign in or sign up before continuing.')
        end
      end
    end
  end
end
