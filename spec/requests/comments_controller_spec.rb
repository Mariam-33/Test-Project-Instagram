# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'devise'

RSpec.describe CommentsController, type: :request do
  let!(:photo) { create(:photo) }
  let(:unauth_user) { create(:user, :unauthorized) }
  let(:post2) { create(:post) }
  let(:user) { post2.user }
  let(:comment) { Comment.create(id: 1, statement: Faker::Lorem.sentence, post_id: post2.id, user_id: user.id) }
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
        it 'is not allowed for signed out user to create comment' do
          post post_comments_path(post2.id)
          follow_redirect!
          expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
        end
        it 'is not allowed for unauthorized user to create comment' do
          sign_in unauth_user
          post post_comments_path(post2.id), params: {
            comment: { user_id: unauth_user.id, post_id: post2.id, statement: comment.statement },
            format: :js
          }
          follow_redirect!
          expect(flash[:alert]).to eql('You are not authorized to perform this action.')
        end
      end
    end
  end

  describe 'Comments/update' do
    context 'Allow comment updation' do
      it 'is allowed for signed in and authorized user to update comment' do
        patch post_comment_path(comment.post.id, comment.id),
              params: { comment: { statement: 'Hellloo', user_id: user.id }, format: :js }
        expect(response.content_type).to eq('text/javascript')
      end
    end
    context 'Do not allow comment creation' do
      it 'is not allowed to update comment if params are incorrect-shorter' do
        patch post_comment_path(comment.post.id, comment.id),
              params: { comment: { statement: Faker::Lorem.characters(number: 2), user_id: user.id }, format: :js }
        expect(flash[:alert]).to eql('Something went wrong')
      end
      it 'is not allowed to update comment if params are incorrect-longer' do
        patch post_comment_path(comment.post.id, comment.id),
              params: { comment: { statement: Faker::Lorem.characters(number: 501), user_id: user.id }, format: :js }
        expect(flash[:alert]).to eql('Something went wrong')
      end
      context 'User has signed out' do
        before do
          sign_out user
        end
        it 'is not allowed for unauthorized user to update comment' do
          sign_in unauth_user
          patch post_comment_path(comment.post.id, comment.id), params: { comment: {
            statement: Faker::Lorem.sentence, user_id: unauth_user.id
          }, format: :js }
          follow_redirect!
          expect(flash[:alert]).to eql('You are not authorized to perform this action.')
        end
        it 'is not allowed to update comment if user has signed out' do
          patch post_comment_path(comment.post.id, comment.id)
          follow_redirect!
          expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
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
        expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
      end
    end
  end
  describe 'Comments/destroy' do
    context 'Allow comment deletion' do
      it 'is allowed for authorized and signed in user to delete comment' do
        delete post_comment_path(comment.post.id, comment.id), params: { format: :js }
        expect(response.content_type).to eq('text/javascript')
      end
    end
    context 'Do not allow comment deletion' do
      it 'is not allowed to delete comment if action return false' do
        allow(Comment).to receive(:find).and_return(comment)
        allow(comment).to receive(:destroy).and_return(false)
        delete post_comment_path(comment.post.id, comment.id), params: { format: :js }
        expect(flash[:alert]).to eql('Comment not destroyed')
      end
      it 'is not allowed to delete comment if nil ids are passed' do
        expect do
          delete post_comment_path
        end.to raise_exception(ActionController::UrlGenerationError)
      end
      context 'User has signed out' do
        before do
          sign_out user
        end
        it 'is not allowed for unauthorized user to delete comment' do
          sign_in unauth_user
          delete post_comment_path(comment.post.id, comment.id),
                 params: { format: :js }
          follow_redirect!
          expect(flash[:alert]).to eql('You are not authorized to perform this action.')
        end
        it 'is not allowed to delete comment if user has signed out' do
          delete post_comment_path(comment.post.id, comment.id)
          follow_redirect!
          expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
        end
      end
    end
  end
end
