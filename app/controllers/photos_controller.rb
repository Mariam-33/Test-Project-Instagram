# frozen_string_literal: true

# Photos controller
class PhotosController < ApplicationController
  before_action :set_photable, only: %i[index create]
  def index
    @photos = @photoable.photos
  end

  def create
    @photo = @photoable.photos.build(params[:photo])
    if @photo.save
      flash[:notice] = 'Successfully created photo.'
      redirect_to id: nil
    else
      render action: 'new'
    end
  end

  def destroy
    @post = @photoable
    @photo = @post.photos.create(photos_params)
    @photo.destroy
    redirect_to post_path(@post)
  end

  private

  def find_photoable
    @photoable = Photo.find(params[:photo_id]) if params[:photo_id]
    @photoable = Photo.find(params[:story_id]) if params[:story_id]
  end

  def set_photoable
    @photoable = find_photoable
  end
end
