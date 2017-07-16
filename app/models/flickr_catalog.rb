require 'flickraw'
class FlickrCatalog < Catalog
  before_destroy :delete_contents
  serialize :ext_store_data, Hash

  def auth()
    self.appkey = Rails.configuration.flickr["appkey"]
    self.appsecret = Rails.configuration.flickr["appsecret"]
    # self.appkey = Rails.configuration.x.flickr["appkey"]
    # self.appsecret = Rails.configuration.x.flickr["appsecret"]
    base_url = Rails.configuration.phototank["api_base_url"]
    url_ext = "/api/catalogs/oauth_verify.json"
    params = "?id=#{self.id}&token=#{self.user.remember_token}"
    self.redirect_uri = "#{base_url}#{url_ext}#{params}"
    FlickRaw.api_key=self.appkey
    FlickRaw.shared_secret = self.appsecret

    flickr = FlickRaw::Flickr.new
    token = flickr.get_request_token(:oauth_callback => URI.escape(self.redirect_uri))
    # You'll need to store the token somewhere for when the user is returned to the callback method
    # I stick mine in memcache with their session key as the cache key
    self.request_token = token
    self.auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')
    self.save
    # Stick @auth_url in your template for users to click
  end

  # Your users browser will be redirected here from Flickr (see @callback_url above)
  def callback
    begin
      flickr = FlickRaw::Flickr.new

      request_token = self.request_token
      access_token = request_token[:oauth_token]
      oauth_verifier = self.verifier

      raw_token = flickr.get_access_token(request_token['oauth_token'], request_token['oauth_token_secret'], oauth_verifier)
      # raw_token is a hash like this {"user_nsid"=>"92023420%40N00", "oauth_token_secret"=>"XXXXXX", "username"=>"boncey", "fullname"=>"Darren%20Greaves", "oauth_token"=>"XXXXXX"}
      # Use URI.unescape on the nsid and name parameters

      self.access_token = raw_token["oauth_token"]
      self.oauth_token_secret = raw_token["oauth_token_secret"]
      self.save
      return 1
    rescue Exception => e
      return 0
    end

  end

  def import(use_resque=true)
    raise "Catalog is not online" unless online
    if not self.sync_from_catalog.blank?
        LocalCloneInstancesFromCatalogJob.perform_later self.id, self.sync_from_catalog
    end
  end

  def import_photo(photo_id)

    # pf = PhotoFilesApi::Api::new

    photo = Photo.find(photo_id)
    instance = photo.instances.where(catalog_id: self.id).first
    photofile = Photofile.find(photo.org_id) #pf.show(photo.org_id)

    if instance.status != 1
      #file = Tempfile.new("Flickr_")
      begin
        #file.binmode
        #file.write open(photofile[:url]).read
        src = photofile.path

        response = self.client.upload_photo src, :title=> photofile.path, :tags=>get_flickr_tags(photo_id)

        #self.set_tags response, photo.id
        instance.touch
        instance.update(rev: response, status: 1)
      rescue Exception => e
        raise e
      ensure
        #file.close
        #file.unlink
      end
    end
  end

  def exists(photo_id)
    tag_string = get_flickr_tags(photo_id).gsub(' ', ',')
    response = self.client.photos.search :tags=>tag_string, :user_id=> self.user_id
    if response.length > 0
      true
    else
      false
    end
  end

  def set_tags(flickr_id, photo_id)
    tag_string = get_flickr_tags(photo_id )
    self.client.photos.setTags :photo_id=>flickr_id, :tags=> tag_string
  end

  def online
    true if access_token
  end

  def delete_contents
    # triggered when entire catalog is deleted. This will delete all instances,
    # and in turn the photos through delete_photo
    instances.each do |instance|
      instance.destroy
    end
  end

  def delete_photo(photo_id)
    begin
      instance = self.instances.where(photo_id: photo_id).first
      if not instance.nil?
        response = self.client.photos.delete :photo_id=>instance.rev
      end
      #instance.destroy
    rescue Exception => e
      logger.debug "#{e}"
    end
  end

  def auth_url=(new_auth_url)
    self.ext_store_data = self.ext_store_data.merge({:auth_url => new_auth_url})
  end

  def auth_url
    self.ext_store_data[:auth_url]
  end

  def appkey=(new_appkey)
    self.ext_store_data = self.ext_store_data.merge({:appkey => new_appkey})
  end

  def appkey
    self.ext_store_data[:appkey]
  end

  def appsecret=(new_appsecret)
    self.ext_store_data = self.ext_store_data.merge({:appsecret => new_appsecret})
  end

  def appsecret
    self.ext_store_data[:appsecret]
  end

  def redirect_uri=(new_redirect_uri)
    self.ext_store_data = self.ext_store_data.merge({:redirect_uri => new_redirect_uri})
  end

  def redirect_uri
    self.ext_store_data[:redirect_uri]
  end

  def verifier=(new_verifier)
    self.ext_store_data = self.ext_store_data.merge({:verifier => new_verifier})
  end

  def verifier
    self.ext_store_data[:verifier]
  end

  def request_token=(new_request_token)
    self.ext_store_data = self.ext_store_data.merge({:request_token => new_request_token})
  end

  def request_token
    self.ext_store_data[:request_token]
  end

  def access_token=(new_access_token)
    self.ext_store_data = self.ext_store_data.merge({:access_token => new_access_token})
  end

  def access_token
    self.ext_store_data[:access_token]
  end

  def oauth_token_secret=(new_oauth_token_secret)
    self.ext_store_data = self.ext_store_data.merge({:oauth_token_secret => new_oauth_token_secret})
  end

  def oauth_token_secret
    self.ext_store_data[:oauth_token_secret]
  end

  def flickr_user_id
    self.ext_store_data[:user_id]
    # Rails.cache.fetch("flickr/user_id/#{self.id}", expires_in: 10.days) do
    #   response = self.client.test.login
    #   response["id"]
    # end
  end


  def client

    if not defined? @client
      FlickRaw.api_key= self.appkey
      FlickRaw.shared_secret= self.appsecret

      flickr.access_token = self.access_token
      flickr.access_secret = self.oauth_token_secret
      @client = flickr
    end
    @client
  end

  private

  def get_flickr_tags(photo_id)

    instance_name = Rails.configuration.phototank["instance_name"]
    "photo_id:#{photo_id} catalog_id:#{self.id} PHOTOTANK #{instance_name}"
  end

end
