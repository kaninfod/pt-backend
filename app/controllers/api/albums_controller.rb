module Api
  class AlbumsController < ApplicationController
    def show
      @bucket = session[:bucket]
      @album = Album.find(params[:id])

      #Get photos
      @photos = @album.photos.paginate(:page => params[:page], :per_page => 40)

      #If this was requested from an ajax call it should be rendered with slim view
      if request.xhr?
        render :partial=>"photos/grid"
      end
    end

    def index
      # order = params[:order] unless not params.has_key?(:order)
      # query = "%#{params[:q]}%"
      # query ||="%"
      # @albums = Album.order(order).where("name LIKE ?", query).paginate(:page => params[:page], :per_page => 20)
      @albums = Album.all
    end

    def edit
      @album = Album.find(params[:id])
      taglist=ActsAsTaggableOn::Tag.where(id:@album.tags)
      @tags = taglist.map do |e|
        {:id=> e.id.to_s, :value=>e.name}
      end

      prep_form
    end

    def update
      @album = Album.find(params[:id])
      respond_to do |format|
        if @album.update(album_params)
          tags = params[:album][:tags].split(',').map(&:to_i)
          @album.update(tags: tags)
          format.html { redirect_to @album, notice: 'Album was successfully updated.' }
          format.json { render :show, status: :ok, location: @album }
        else
          format.html { render :edit }
          format.json { render json: @album.errors, status: :unprocessable_entity }
        end
      end
    end


    def new
      @album = Album.new
      prep_form
    end

    def create
      @album = Album.new(album_params)

      respond_to do |format|
        if @album.save
          format.html { redirect_to @album, notice: 'Album was successfully created.' }
          format.json { render :show, status: :created, location: @album }
        else
          format.html { render :new }
          format.json { render json: @album.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @album = Album.find(params[:id])
      @album.destroy
      respond_to do |format|
        format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def select
      if request.post?
        if not params[:optionsRadios].blank?
          album = Album.find(params[:optionsRadios].to_i)
          a = (album.photo_ids + session[:bucket]).uniq{|x| x}
          album.photo_ids = a
          if album.save
            redirect_to '/albums'
          end
        end
      else
        @albums = Album.all.page params[:page]
      end


    end

    def add_photo
      album = Album.find params[:album]
      album.photo_ids.push(params[:photo]) unless album.photo_ids.include? params[:photo_id]
      album.save

      render :json => {status: 200}



    end

    private


      def album_params
        params.require(:album).permit(:start, :end, :name, :make, :model, :country, :city, :photo_ids, :album_type, {:tags=>[123]})
      end

      def prep_form
        @countries = Location.distinct_countries
        @cities = Location.distinct_cities
        @makes = Photo.distinct_makes
        @models = Photo.distinct_models
        @bucket = session[:bucket]
      end


  end
end
