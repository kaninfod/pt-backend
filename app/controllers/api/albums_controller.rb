module Api
  class AlbumsController < ApplicationController
    set_pagination_headers :photos, only: [:photos]
    before_action :set_album, only: [:show, :update, :destroy, :photos, :add_photo]
    include Response
    include ExceptionHandler



    # PUT /albums/:id/photo/:id
    def add_photo
      @album.add_photos([params[:photo]])
      json_response(@album.album_photos)
    end

    # GET /albums
    def index
      @albums = Album.all
      return @albums
      json_response(@albums)
    end

    # GET /albums/:id/photos
    def photos
      # json_response(@album.album_photos.paginate(:page => params[:page], :per_page=>60))
      @photos = @album.album_photos.paginate(:page => params[:page], :per_page=>60)
      render 'api/photos/index'
    end

    # GET /albums/:id
    def show
      json_response(@album)
    end

    # POST /albums
    def create
      @album = Album.create!(album_params)
      json_response(@album, :created)
    end

    # PUT /albums/:id
    def update
      @album.update(album_params)
      json_response(@album, :accepted)
    end

    # DELETE /albums/:id
    def destroy
      @album.destroy
      head :no_content
    end

    private

      def album_params
        params.require(:album).permit(:start, :end, :name, :make, :model, :country, :city, :photo_ids, :album_type, {:tags=>[123]})
      end

      def set_album
        @album = Album.find(params[:id])
      end

  end
end


# def new
#   @album = Album.new
#   # prep_form
# end

      # def prep_form
      #   @countries = Location.distinct_countries
      #   @cities = Location.distinct_cities
      #   @makes = Photo.distinct_makes
      #   @models = Photo.distinct_models
      #   @bucket = session[:bucket]
      # end



    # def photos
    #   @album = Album.find(params[:id])
    #   @photos = @album.photos.paginate(:page => params[:page], :per_page => 60)
    #   render 'api/photos/index'
    # end

    # def show
    #   @bucket = session[:bucket]
    #   @album = Album.find(params[:id])
    #
    #   #Get photos
    #   @photos = @album.photos.paginate(:page => params[:page], :per_page => 40)
    #
    #   #If this was requested from an ajax call it should be rendered with slim view
    #   if request.xhr?
    #     render :partial=>"photos/grid"
    #   end
    # end

    # def index
    #   # order = params[:order] unless not params.has_key?(:order)
    #   # query = "%#{params[:q]}%"
    #   # query ||="%"
    #   # @albums = Album.order(order).where("name LIKE ?", query).paginate(:page => params[:page], :per_page => 20)
    #   @albums = Album.all
    # end

    # def edit
    #   @album = Album.find(params[:id])
    #   taglist=ActsAsTaggableOn::Tag.where(id:@album.tags)
    #   @tags = taglist.map do |e|
    #     {:id=> e.id.to_s, :value=>e.name}
    #   end
    #
    #   prep_form
    # end

    # def update
    #   @album = Album.find(params[:id])
    #   respond_to do |format|
    #     if @album.update(album_params)
    #       tags = params[:album][:tags].split(',').map(&:to_i)
    #       @album.update(tags: tags)
    #       format.html { redirect_to @album, notice: 'Album was successfully updated.' }
    #       format.json { render :show, status: :ok, location: @album }
    #     else
    #       format.html { render :edit }
    #       format.json { render json: @album.errors, status: :unprocessable_entity }
    #     end
    #   end
    # end

    #
    # def create
    #   @album = Album.new(album_params)
    #
    #   respond_to do |format|
    #     if @album.save
    #       format.html { redirect_to @album, notice: 'Album was successfully created.' }
    #       format.json { render :show, status: :created, location: @album }
    #     else
    #       format.html { render :new }
    #       format.json { render json: @album.errors, status: :unprocessable_entity }
    #     end
    #   end
    # end

    # def destroy
    #   @album = Album.find(params[:id])
    #   @album.destroy
    #   respond_to do |format|
    #     format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
    #     format.json { head :no_content }
    #   end
    # end

    # def select
    #   if request.post?
    #     if not params[:optionsRadios].blank?
    #       album = Album.find(params[:optionsRadios].to_i)
    #       a = (album.photo_ids + session[:bucket]).uniq{|x| x}
    #       album.photo_ids = a
    #       if album.save
    #         redirect_to '/albums'
    #       end
    #     end
    #   else
    #     @albums = Album.all.page params[:page]
    #   end
    # end

    # def add_photo
    #   album = Album.find params[:album]
    #   album.photo_ids.push(params[:photo]) unless album.photo_ids.include? params[:photo_id]
    #   album.save
    #
    #   render :json => {status: 200}
    # end
