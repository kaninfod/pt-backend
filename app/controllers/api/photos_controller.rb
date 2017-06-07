module Api
  class PhotosController < ApplicationController
    include BucketActions
    set_pagination_headers :photos, only: [:index]

    def image
      @photo = set_photo
      send_file @photo.get_photo(params[:size]), :disposition => 'inline'
    end

    def valid_date
      d = params[:date].to_date
      case params[:type]
      when 'day'
        ary = Photo.days(d.year, d.month).map{ |f| f.value }
      when 'month'
        ary = Photo.months(d.year).map{ |f| f.value }
      when 'year'
        ary = Photo.years.map{ |f| f.value }
      end
      render json: ary
    end

    def index
      logger.debug "this is a test! pt-con"
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
        album_hash[:country] = params[:country] unless params[:country] == "All"
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
      #Get photos
      @photos = @album.photos.where('photos.status != ? or photos.status is ?', 1, nil).order(date_taken: order).paginate(:page => params[:page], :per_page=>60)

      #@bucket = Bucket.where(user: @current_user.id)
    end

    def show
      if params.has_key?(:size)
        @size = params[:size]
      else
        @size = 'medium'
      end
      @photo = Photo.find(params[:id])
      @bucket = session[:bucket]
      @albums = Album.all
    end

    def edit
      @photo = Photo.find(params[:id])
      session[:finalurl] = request.referer
      @submit_path = "/photos/#{params[:id]}"
    end

    def update
      if request.xhr?
        data = params[:_json].map{|a| {a["name"]=>a["value"]}}.reduce({}, :merge)
        data = data.reject { |k,v| v.empty? }
        data = data.delete_if { |k,v| k == "location_address" }
        photo = Photo.find(params[:id])
        if photo.update(data)
          PhotoUpdateExif.perform_later photo.id
        end
      end
      render json: {'ok'=>1}
    end

    def rotate
      @photo = Photo.find(params[:id]).id
      rotate_helper([@photo], params[:degrees])
      render :json => {:status => true}
    end

    def destroy
      photo = Photo.find(params[:id])
      if photo.delete
        render json: {:status=> 200, photo_id: photo.id}
      end
      # respond_to do |format|
      #   format.html {
      #     flash[:notice] = 'Photo has been queued for deletion'
      #     redirect_to request.referer
      #   }
      #   format.json {
      #     render json: {:notice=>'Photo has been queued for deletion'}
      #   }
      # end

    end

    def add_comment
      photo_id = params[:id]
      if params.has_key? "comment"
        comment = add_comment_helper(photo_id, params[:comment])
        @comments = Photo.find(photo_id).comments
        render :partial => 'comments', locals: {comments: @comments}
      end
    end

    def like
      photo = Photo.find(params[:id])
      if current_user.voted_for? photo
        photo.unliked_by current_user
      else
        photo.liked_by current_user
      end
      render :json => {:likes => photo.votes_for.size, :liked_by_current_user => (current_user.voted_for? photo)}
    end

    def addtag
      photo = Photo.find params[:id]

      if params[:name][0,1] == "@"
        photo.objective_list.add params[:name]
      else
        photo.tag_list.add params[:name]
      end

      if photo.save
        render :json => {:tags => photo.tags}
      else
        render :status => "500"
      end
    end

    def removetag

      photo = Photo.find params[:id]

      if params[:name][0,1] == "@"
        photo.objective_list.remove params[:name]
      else
        photo.tag_list.remove params[:name]
      end

      if photo.save
        render :json => {:tags => photo.tags}
      else
        render :status => "500"
      end
    end

    def get_tag_list
      if params.has_key?(:photo_id)
        photo = Photo.where(id: params[:photo_id])
        if !photo.empty?
          taglist = photo.first.tags
        else
          taglist = []
        end
      elsif params.has_key?(:term)
        query_string = params[:term]
        taglist = ActsAsTaggableOn::Tag.where("name like ?", "%#{query_string}%").limit(10)
      end
      autocomplete_list = taglist.map do |e|
        {:id=> e.id, :name=>e.name}
      end
      render :json => autocomplete_list
    end

    private

    def set_date(query)
      start = {:year=>Date.today.year, :month=>Date.today.month, :day=>Date.today.day}
      if query != nil
        [:year, :month, :day].each do |t|
          start[t]=query[t].to_i unless not query.has_key?(t)
        end
      end

      if query == nil
        @searchbox = {
            :type=>"all",
            :values => Photo.years}
      elsif query.has_key?(:day)
        @searchbox = {
            :type => "day",
            :values => Photo.days(start[:year], start[:month])}
      elsif query.has_key?(:month)
        @searchbox = {
            :type=>"month",
            :values => Photo.days(start[:year], start[:month])}
      elsif query.has_key?(:year)
        @searchbox = {
            :type=>"year",
            :values => Photo.months(start[:year])}
      else
        @searchbox = {
            :type=>"all",
            :values => Photo.years}
      end
      @searchbox[:day] = start[:day]
      @searchbox[:month] = start[:month]
      @searchbox[:year] = start[:year]
      start = Date.new(start[:year], start[:month], start[:day])

    end

    def album_params
      params.require(:album).permit(:start, :end, :name, :make, :model, :country, :city, :photo_ids, :album_type)
    end

    def getCountries
      @countries = Location.distinct_countries
      @countries[0] = "All"
      #@bucket = session[:bucket]
    end

      # Use callbacks to share common setup or constraints between actions.
      def set_photo
        Photo.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def photo_params
        params.require(:photo).permit(:filename, :date_taken, :path, :file_thumb_path, :file_extension, :file_size, :location_id, :make, :model, :original_height, :original_width, :longitude, :latitude)
      end
  end
end
