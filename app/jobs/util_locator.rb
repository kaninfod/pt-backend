class UtilLocator < AppJob
  include Resque::Plugins::UniqueJob
  queue_as :utility

  def perform(photo_id)
    begin
      @photo = Photo.find(photo_id)
      location = get_location

      @photo.location = location
      @photo.save

      @job_db.update(jobable_id: @photo.id, jobable_type: "Photo")
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end
  end

  private

  def get_location
    location = no_coordinates
    return location if !location.nil?

    location = reuse_location
    return location if !location.nil?

    location = geosearch
    return location if !location.nil?
  end

  def save_map
    file = Tempfile.new("temp.tmp")
    file.binmode
    file.write open(@photo.location.get_google_map).read
    file.close
    payload = {
      :path=> file.path,
      :filetype=> "map"
    }
    response = Photofile.create(data: payload)
    @photo.location.update(map_image_id: response[:id])
    @photo.save
    file.unlink
  end

  def get_no_location
    loc = Location.where(status:100)
    if loc.length > 0
      return loc.first
    else
      loc = Location.create(latitude:0, longitude:0, country:"N/A", status:100)
      return loc
    end
  end

  def no_coordinates()
    if @photo.latitude.blank? || @photo.longitude.blank?
      @photo.location = get_no_location
      return get_no_location
    end
  end

  def reuse_location()
    similar_locations = @photo.nearbys(1).where.not(location_id: nil)
    if similar_locations.count(:all) > 0
      @photo.location = similar_locations.first.location
      return similar_locations.first.location
    end
  end

  def geosearch
    if geo_location = Geocoder.search(@photo.coordinate_string).first
      if geo_location.data["error"].blank?
        new_location = Location.new
        new_location.country = geo_location.country
        new_location.city = geo_location.city
        # new_location.suburb = geo_location.suburb
        new_location.postcode = geo_location.postal_code
        new_location.address = geo_location.address
        new_location.state = geo_location.state
        new_location.longitude = geo_location.longitude
        new_location.latitude = geo_location.latitude
        new_location.save
        @photo.location = new_location
        save_map
        return new_location
      else
        return temp_location
      end
    else
      return temp_location
    end
  end

  def temp_location
    loc = Location.where(status:200)
    if loc.length > 0
      return loc.first
    else
      loc = Location.create(latitude:0, longitude:0, country:"N/A", status:200)
      return loc
    end
  end
end
