module Api
  class PhotosController < ApplicationController
    include BucketActions
    set_pagination_headers :photos, only: [:index]
    before_action :set_photo, only: [:destroy, :rotate, :show, :add_to_album, :addtag, :removetag, :add_comment, :like]

    def index
      album_hash = {}
      @searchparams = {}

      if params.has_key? :direction
        case params[:direction]
          when "true"
            album_hash[:start] = params[:startdate]
            @searchparams[:direction] = "true"
            order = "asc"
          when "false"
            album_hash[:end] = params[:startdate]
            @searchparams[:direction] = "false"
            order = "desc"
        end
      else
        order = "desc"
        album_hash[:end] = params[:startdate]
        @searchparams[:direction] = "false"
      end

      if params.has_key? "country"
        album_hash[:country] = params[:country] unless params[:country] == "-1"
      end

      if params.has_key? "like"
        album_hash[:like] = params[:like]
      end

      if params.has_key? "tags"
        if params[:tags].is_a?(Array)
          tags = params[:tags].map{|t| ActsAsTaggableOn::Tag.all.where(name: t).first.id}
          album_hash[:tags] = tags
        end
      end

      @album = Album.new(album_hash)
      logger.debug album_hash
      #Get photos
      @photos = @album.album_photos.where('photos.status != ? or photos.status is ?', 1, nil).order(date_taken: order).paginate(:page => params[:page], :per_page=>60)

      #@bucket = Bucket.where(user: @current_user.id)
    end

    def show
      if params.has_key?(:size)
        size = params[:size]
      else
        size = 'medium'
      end
      # @photo = Photo.find(params[:id])
      @bucket = session[:bucket]
      @taglist = ActsAsTaggableOn::Tag.all
      @albums = Album.all
    end

    def rotate
      # @photo = Photo.find(params[:id])
      rotate_helper([@photo.id], params[:degrees])
      render :json => {:status => true}
    end

    def destroy
      if @photo.delete
        render json: {:status=> 200, photo_id: photo.id}
      end
    end

    def add_comment
      # photo_id = params[:id]
      if params.has_key? "comment"
        comment = add_comment_helper(@photo.id, params[:comment])
        @comments = Photo.find(@photo.id).comments
        render :partial => 'comments', locals: {comments: @comments}
      end
    end

    def like
      # photo = Photo.find(params[:id])
      if current_user.voted_for? @photo
        @photo.unliked_by current_user
      else
        @photo.liked_by current_user
      end
      render :json => {:likes => @photo.votes_for.size, :liked_by_current_user => (current_user.voted_for? @photo)}
    end

    def addtag
      # photo = Photo.find params[:id]
      if params[:name][0,1] == "@"
        @photo.objective_list.add params[:name]
      else
        @photo.tag_list.add params[:name]
      end

      if @photo.save
        render :json => {:tags => @photo.tags}
      else
        render :status => "500"
      end
    end

    def removetag
      # photo = Photo.find params[:id]

      if params[:name][0,1] == "@"
        @photo.objective_list.remove params[:name]
      else
        @photo.tag_list.remove params[:name]
      end

      if @photo.save
        render :json => {:tags => @photo.tags}
      else
        render :status => "500"
      end
    end


    private

      # Use callbacks to share common setup or constraints between actions.
      def set_photo
        @photo = Photo.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def photo_params
        params.require(:photo).permit(:filename, :date_taken, :path, :file_thumb_path, :file_extension, :file_size, :location_id, :make, :model, :original_height, :original_width, :longitude, :latitude)
      end
  end
end
