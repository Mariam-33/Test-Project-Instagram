# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'devise'

RSpec.describe PostsController, type: :request do
  let!(:photo) { create(:photo) }
  let(:unauth_user) do
    User.create(username: Faker::Name.name, email: Faker::Internet.email,
                password: Faker::Alphanumeric.alphanumeric(number: 8))
  end
  let(:post1) { create(:post) }
  let(:user) { post1.user }
  before(:each) do
    unauth_user.confirm
    sign_in user
  end
  describe 'Posts/new' do
    context 'Allow rendering new' do
      it 'is allowed to render new if authorized user is signed in' do
        get new_post_path
        expect(response).to have_http_status(200)
      end
    end
    context 'Do not allow rendering new' do
      it 'is not allowed to render new if user is not signed in' do
        sign_out user
        get new_post_path
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end
  describe 'Posts/show' do
    context 'Allow rendering post' do
      it 'is allowed to render post if authorized user is signed in' do
        get post_path(post1.id)
        expect(response).to have_http_status(200)
      end
    end
    context 'Do not allow rendering post' do
      before do
        sign_out user
      end
      it 'is not allowed to render post if user is unauthorized' do
        sign_in unauth_user
        get post_path(post1.id)
        follow_redirect!
        expect(response.body).to include('You are not authorized to perform this action')
      end
      it 'is not allowed to render post if user is signed out' do
        get post_path(post1.id)
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end
  describe 'Posts/create' do
    context 'Allow post creation' do
      it 'is allowed to create post with right params i.e. images' do
        post posts_path,
             params: { user_id: user.id, description: post1.description,
                       images: [fixture_file_upload(Rails.root.join('spec/fixtures/xabout.png'), 'image/png')] }
        follow_redirect!
        expect(flash[:notice]).to eql('Post created successfully')
      end
    end
    context 'Do not allow post creation' do
      it 'is not allowed to create post without right params i.e. images' do
        post posts_path, params: { user_id: user.id, description: post1.description,
                                   images: nil }
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eql(['Please attach images within range of 1-10 per post'])
      end
      it 'is not allowed to create post if user is signed out' do
        sign_out user
        post posts_path, params: { id: 6, user_id: user.id, description: post1.description,
                                   images: nil }
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end
  describe 'Post/destroy' do
    context 'Allow post deletion' do
      it 'is allowed to delete post if user is authorized and signed in' do
        delete "/posts/#{post1.id}", params: { user_id: user.id }
        follow_redirect!
        expect(flash[:notice]).to eql('Post is destroyed successfully')
      end
    end
    context 'Do not allow post deletion' do
      it 'is not allowed to delete post if delete action fails' do
        allow(Post).to receive(:find).and_return(post1)
        allow(post1).to receive(:destroy).and_return(false)
        delete "/posts/#{post1.id}"
        follow_redirect!
        expect(response.body).to include('Something went wrong')
      end
      context 'if user is signed out' do
        before do
          sign_out user
        end
        it 'is not allowed to delete post by unauthorized user' do
          sign_in unauth_user
          delete "/posts/#{post1.id}", params: { user_id: unauth_user.id }
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action')
        end

        it 'is not allowed to delete post if user has signed out' do
          delete "/posts/#{post1.id}"
          follow_redirect!
          expect(response.body).to include('You need to sign in or sign up before continuing.')
        end
      end
    end
  end

  describe 'Posts/index' do
    context 'Allow post index view' do
      it 'is allowed for authorized user to see posts' do
        get posts_path, params: { user_id: user.id }
        expect(response).to have_http_status(200)
      end
    end
    context 'Do not allow post index view' do
      before do
        sign_out user
      end
      it 'is not allowed to see posts if user has signed out' do
        get posts_path(user.id)
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
      it 'is not allowed for authorized user to see posts' do
        sign_in unauth_user
        get posts_path(user.id)
        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'Posts/edit' do
    context 'Allow edit post rendering' do
      it 'is allowed for authorized user and signed in user to edit posts' do
        get edit_post_path(post1.id)
        expect(response).to have_http_status(200)
      end
    end
    context 'Do not allow edit post rendering' do
      before do
        sign_out user
      end
      it 'is not allowed for signed out user to edit posts' do
        get edit_post_path(post1.id)
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
      it 'is not allowed for unauthorized user to edit posts' do
        sign_in unauth_user
        get edit_post_path(post1.id)
        follow_redirect!
        expect(response.body).to include('You are not authorized to perform this action')
      end
    end
  end

  describe 'Posts/update' do
    context 'Allow post updation' do
      it 'is allowed for signed in and authorized user to update post with right params' do
        put "/posts/#{post1.id}",
            params: { user_id: user.id, description: post1.description,
                      images: [fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'), 'image/png')] }
        follow_redirect!
        expect(flash[:notice]).to eql('Post updated successfully')
      end
    end
    context 'Do not allow post updation' do
      context 'User has signed out' do
        before do
          sign_out user
        end
        it 'is not allowed for unauthorized user to edit post' do
          sign_in unauth_user
          put "/posts/#{post1.id}",
              params: { user_id: user.id, description: post1.description,
                        images: [fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'), 'image/png')] }
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action')
        end
        it 'is not allowed for signed out user to edit post' do
          put "/posts/#{post1.id}",
              params: { user_id: user.id, description: post1.description,
                        images: [fixture_file_upload(Rails.root.join('spec/fixtures/xdoc-3.png'), 'image/png')] }
          follow_redirect!
          expect(response.body).to include('You need to sign in or sign up before continuing.')
        end
      end
      it 'is not allowed for user to edit post with wrong params' do
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
end
