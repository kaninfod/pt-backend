module Api
  class BucketController < ApplicationController
    include BucketActions

    def add
      if Photo.where(id: params[:id]).present?
        Bucket.create(user: @current_user.id, photo_id: params[:id])
        @bucket = Bucket.where(user: @current_user.id)
        render :status => 200, json: {
          msg: "Photo added to bucket",
          photo_id: params[:id],
          bucket: @bucket
        }
      else
        render :status => 404, json: {error: "photo not found"}
      end

    end

    def remove
      entry = Bucket.where(user: @current_user.id, photo_id: params[:id])
      if entry.count == 1
        entry.first.destroy
        @bucket = Bucket.where(user: @current_user.id)
        render :status => 200, json: {
          msg: "Photo removed from bucket",
          photo_id: params[:id],
          bucket: @bucket
        }
      else
        render :status => 404, json: {error: "photo not in bucket"}
      end
    end

    def toggle
      entry = Bucket.where(user: @current_user.id, photo_id: params[:id])
      if entry.count == 1
        entry.first.destroy
        code = 200
        msg = "Photo removed from bucket"
        action= 'removed'
      elsif Photo.where(id: params[:id]).present?
        Bucket.create(user: @current_user.id, photo_id: params[:id])
        code = 201
        msg = "Photo added to bucket"
        action= 'added'
      else
        code = 404
        msg = "can't do anything"
        action= 'error'
      end

      @output = {
        status: code,
        response: {
          action: action,
          msg: msg,
          photo_id: params[:id],
          bucket: Bucket.where(user: @current_user.id)
        }
      }
    end

    def clear
      session[:bucket] = []
      redirect_to bucket_path
    end

    def count
      render :json => {'count' => session[:bucket].count}
    end

    def index
      @bucket = Bucket.where(user: @current_user.id)
    end

    def widget
      @bucket = Bucket.where(user: @current_user.id)
      @albums = Album.all
    end

    def add_to_album
      if params.has_key? :album_id
        bucket = Bucket.where(user: @current_user.id)
        if params[:album_id].to_i == -1
          album = Album.new
          album.name = "Saved from bucket"
          album.photo_ids = bucket.pluck(:id)
          album.save
        else
          album = Album.find params[:album_id]
          album.photo_ids = [*album.photo_ids, *bucket.pluck(:id)]
          album.save
        end
      end
      render :json => {:status => "OK"}

    end

    def rotate
      if params.has_key? "degrees"
        bucket = Bucket.where(user: @current_user.id)
        rotate_helper(bucket.pluck(:photo_id), params[:degrees])
        render :json => {:bucket => bucket.pluck(:id)}
      else
        render :status => 304, json: {error: "no params"}
      end
    end

    def like
      bucket = Bucket.where(user: @current_user.id)
      bucket.each do |bucket|
        bucket.photo.liked_by current_user
      end
      render :json => {:bucket => bucket.pluck(:id)}
    end

    def unlike
      bucket = Bucket.where(user: @current_user.id)
      bucket.each do |bucket|
        bucket.photo.unliked_by current_user
      end
      render :json => {:bucket => bucket.pluck(:id)}
    end

    def add_tag
      if params.has_key? "tag"
        bucket = Bucket.where(user: @current_user.id)
        bucket.each do |bucket|
          bucket.photo.add_tag params[:tag]
        end
      end
      render :json => {:status => "OK"}
    end

    def add_comment
      if params.has_key? "comment"
        bucket = Bucket.where(user: @current_user.id)
        bucket.each do |bucket|
          bucket.photo.add_comment params[:comment], current_user.id
        end
      end
      render :json => {:status => "OK"}
    end

    def edit
      session[:finalurl] = request.referer
      @submit_path = "/bucket/update"
      @photo = Photo.new
    end

    def update
      @bucket = get_bucket
      Photo.find(@bucket).each do |photo|
        #update the database entry
        if photo.update(params.permit(:date_taken, :location_id))
          #update the exif data on the original photo
          PhotoUpdateExif.perform_later photo.id
        end
      end
      redirect_to session[:finalurl]
    end

    def delete_photos
      session[:bucket].each do |photo_id|
        Photo.find(photo_id).delete
      end
      @bucket = get_bucket
      session[:bucket] = []
      respond_to do |format|
        format.html {
          redirect_to bucket_path
        }
        format.json {
          render json: {:bucket=>@bucket}
        }
      end
    end

    def list
      @bucket = get_bucket
      @photos_in_bucket = Photo.where(id:@bucket)
      @photos_in_bucket =  @photos_in_bucket.index_by(&:id).values_at(*@bucket)
      respond_to do |format|
        format.html {
          render :partial => "list"
        }
        format.json {
          render json: {:bucket=>@bucket}
        }
      end

    end

    private


    def get_bucket
      if session.include? 'bucket'
        session[:bucket]
      else
        session[:bucket] = []
        session[:bucket]
      end
    end


  end
end
