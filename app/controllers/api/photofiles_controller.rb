require 'filemagic'
module Api
  class PhotofilesController < ApplicationController

    PATH = Rails.configuration.x.phototank["filestorepath"]
    ALLOWED_MIMES = ["image/jpeg; charset=binary", "image/png; charset=binary"]

    def index
      @photos = Photofile.all
    end

    def show
      begin
        @photo = Photofile.find(params[:id])
        @photo.url = get_url

      rescue ActiveRecord::RecordNotFound

        render status:404, json: {:msg=>"photo with #{params[:id]} does not exist"}
      end
    end

    def create
      decoded_file = Base64.decode64(params[:file_string])
      file = Tempfile.new("temp.tmp")
      begin
        file.binmode
        file.write decoded_file
        params[:file_string] = ''
        byebug if file.size == 0
        mime = FileMagic.new(FileMagic::MAGIC_MIME).file(file.path)

        if ALLOWED_MIMES.include? mime
            @photo = Photofile.create(path: file.path, datahash: params)
          @photo.url = get_url(@photo.id)
        end

      ensure
        file.close
        file.unlink
      end

    end

    def update
      begin
        decoded_file = Base64.decode64(params[:file_string])
        file = Tempfile.new("temp.tmp")
        begin
          file.binmode
          file.write decoded_file
          mime = FileMagic.new(FileMagic::MAGIC_MIME).file(file.path)

          if ALLOWED_MIMES.include? mime
            @photo = Photofile.find(params[:id])
            @photo.update(data: file.path)
            @photo.url = get_url(@photo.id)
          end

        ensure
          file.close
          file.unlink
        end

      rescue ActiveRecord::RecordNotFound
        render status:404, json: {:msg=>"photo with #{params[:id]} does not exist"}
      end
    end

    def destroy
      begin
        @photo = Photofile.find(params[:id])
        FileUtils.rm @photo.path if File.exists? @photo.path
        @photo.destroy
      rescue ActiveRecord::RecordNotFound
        render status:404, json: {:error=>"photo with #{params[:id]} does not exist"}
      end
    end

    def rotate
      if params[:degrees].blank?
        render status:404, json: {:error=>"invalid rotation (degrees)"}
        return
      end

      begin
        @photo = Photofile.find(params[:id])
        @photo.rotate(params[:degrees])
        @photo.url = get_url
        @degrees = params[:degrees]
      rescue ActiveRecord::RecordNotFound
        render status:404, json: {:error=>"photo with #{params[:id]} does not exist"}
      end
    end

    def phash

      begin
        @photo = Photofile.find(params[:id])
        p = @photo.get_phash
        @photo.phash = p
        @photo.url = get_url

      rescue ActiveRecord::RecordNotFound
        render status:404, json: {:error=>"photo with #{params[:id]} does not exist"}
      end
    end

    def photoserve
      begin
        @photo = Photofile.find(params[:id])
        send_file @photo.path, type: 'image/jpeg', :disposition => 'inline'
      rescue ActiveRecord::RecordNotFound
        @photo = Photofile.find(Setting.generic_image_tm_id)
        send_file @photo.path, type: 'image/jpeg', :disposition => 'inline'
      end
    end

    private
    def get_url(id=false)
      if id == false
        url_for(action: 'photoserve', controller: 'photofiles', only_path: false, protocol: 'http')
      else
        url_for(action: 'photoserve', controller: 'photofiles', only_path: false, protocol: 'http', id: id)
      end
    end
  end
end
