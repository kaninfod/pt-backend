module Api
  class CatalogsController < ApplicationController
    set_pagination_headers :photos, only: [:photos]

    def index
        @catalogs = Catalog.order(:id).page params[:page]
    end

    def photos
      @photos = Photo.paginate(:page => params[:page], :per_page=>60)
      render 'api/photos/index'
    end

    def create_c
      name = params[:name]
      type = params[:type]

      case params[:type]
        when 'MasterCatalog'
          catalog_attribs = params.permit({:watch_path => []}, :default, :name, :type, :path, :import_mode)
          catalog = Catalog.create(catalog_attribs)
        when 'LocalCatalog'

        when 'DropboxCatalog'
          catalog = DropboxCatalog.new(
            name: params[:name],
            sync_from_catalog: params[:sync_from_catalog],
            user_id: @current_user.id
          )
          catalog.redirect_uri = request.base_url
          catalog.save
          catalog.auth
        when 'FlickrCatalog'
          catalog = FlickrCatalog.new(
            name: params[:name],
            sync_from_catalog: params[:sync_from_catalog],
            user_id: @current_user.id
          )
          catalog.redirect_uri = request.base_url
          catalog.save
          catalog.auth
      end
      @catalog = catalog
      render "catalogs/show" #:json => { catalog: catalog }

    end

    def oauth_verify
      id = params[:id]
      verifier = params[:oauth_verifier]
      @catalog = Catalog.find(id)

      @catalog.update(verifier: verifier)
      if @catalog.callback
        render "catalogs/show" #json: {:status=> 200, catalog: Catalog.find(id) }
      else
        render json: {:status=> 502}
      end
    end

    # def create
    #   if ["DropboxCatalog", "FlickrCatalog"].include? params[:catalog][:type]
    #     redirect_to "/catalogs/authorize?name=#{params[:catalog][:name]}&type=#{params[:catalog][:type]}"
    #   else
    #     @catalog = Catalog.new(catalog_params)
    #     if @catalog.save
    #       redirect_to action: 'edit', id:@catalog
    #     end
    #   end
    # end

    # def edit
    #   @catalog = Catalog.find(params[:id])
    #   @catalog_options = [
    #     ['Master','MasterCatalog'],
    #     ['Local','LocalCatalog'],
    #     ['Dropbox','DropboxCatalog'],
    #     ['Flickr','FlickrCatalog']
    #   ]
    #   if @catalog.sync_from_albums.blank?
    #     @sync_from="catalog"
    #   else
    #     @sync_from="album"
    #   end
    # end

    def update
      catalog = Catalog.find(params[:id])

      case params[:type]
        when "MasterCatalog"
          catalog_attribs = update_master
        when "LocalCatalog"
          catalog_attribs = update_local
        when "DropboxCatalog"
          catalog_attribs = update_dropbox
        when "FlickrCatalog"
          catalog_attribs = update_dropbox
      end

      if catalog.update(catalog_attribs)
        render render "catalogs/show" #:json => { catalog: catalog }
      end
    end

    def destroy
      @catalog = Catalog.find(params[:id])
      @catalog.destroy
      redirect_to action: 'index', notice: 'Catalog was successfully destroyed.'
    end

    def show
      # @bucket = session[:bucket]
      @catalog = Catalog.find(params[:id])
      # @photos = @catalog.photos.where('photos.status != ? or photos.status is ?', 1, nil).page params[:page]
      #If this was requested from an ajax call it should be rendered with slim view
      # if request.xhr?
      #   render :partial=>"photos/grid"
      # end
    end

    def dashboard
      @catalog = Catalog.find(params[:id])
      @jobs = Job.order(created_at: :desc, id: :desc ).paginate(:page => params[:page], :per_page => 10)
    end

    def import
      catalog = Catalog.find(params[:id])
      response = catalog.import
      render :json => { response: response }
    end

    def get_catalog
      render :json => Catalog.find(params[:id]).to_json
    end

    def authorize()
      if request.put?
        catalog = DropboxCatalog.find(params[:id])
        catalog.update(verifier: params[:verifier])
        if catalog.callback
          redirect_to action: 'edit', id: catalog
        end
      else
        if params[:type] == 'DropboxCatalog'
          @catalog = DropboxCatalog.new(name: params[:name])
          @catalog.redirect_uri = request.base_url
          @catalog.save
          @auth_url = @catalog.auth
        elsif params[:type] == 'FlickrCatalog'
          catalog = FlickrCatalog.new(name: params[:name])
          catalog.redirect_uri = request.base_url
          catalog.save
          auth_url = catalog.auth
          redirect_to auth_url
        end
      end
    end

    def authorize_callback
      if params.has_key? :type
        if params[:type] == "FlickrCatalog"
          flickr_catalog = FlickrCatalog.find(params[:id])
          flickr_catalog.verifier = params[:oauth_verifier]
          flickr_catalog.save
          if flickr_catalog.callback
            redirect_to action: 'edit', id: flickr_catalog
          end
        end
      else
      end
    end

    private

    def update_master
      catalog_attribs = params.permit(:name, :type, :path, :import_mode)
      catalog_attribs['watch_path'] = generate_watch_path
      #catalog_attribs['import_mode'] = params['import_mode']
      return catalog_attribs
    end

    def update_local
      catalog_attribs = params.permit(:name, :type, :path)
      if params[:sync_from] == "catalog"
        catalog_attribs['sync_from_catalog'] = params[:sync_from_catalog_id]
        catalog_attribs['sync_from_albums'] = nil
      elsif params[:sync_from] == "album"
        albums = []
        params.each do |k, v|
          albums.push(v) if (k.include?('sync_from_album_id_') & not(v.blank?))
        end
        catalog_attribs['sync_from_albums'] = albums
        catalog_attribs['sync_from_catalog'] = nil
      end
      return catalog_attribs
    end

    def update_dropbox
      catalog_attribs = params.permit(:name, :type, :path, :access_token, :verifier)
      catalog_attribs['sync_from_catalog'] = params[:sync_from_catalog_id]
      catalog_attribs['sync_from_albums'] = nil
      return catalog_attribs
      #catalog_attribs['access_token'] = params["access_token"]

    end

    def generate_watch_path
      watch_path =[]
      params.each do |k, v|
        watch_path.push(v) if (k.include?('wp_') & not(v.blank?))
      end
      return watch_path
    end

    def set_catalog
      Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:name, :path, :default, :watch_path, :type, :sync_from_catalog, :sync_from_albums, :import_mode)
    end
  end
end
