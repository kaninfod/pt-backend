class Location < ActiveRecord::Base
  validates :latitude, :longitude, :country, presence: true
  has_many :photos
  reverse_geocoded_by :latitude, :longitude

  scope :distinct_countries, -> {
    ary = select(:country).distinct.map { |c| c.country }.unshift('All')
    ary.delete([nil])
    ary.sort_by{|el| el[0] }
  }
  scope :distinct_cities, -> {
    ary = select(:city).distinct.map { |c| [c.city] }.unshift([''])
    ary.delete([nil])
    ary.sort_by{|el| el[0] }
  }

  def self.geolocate
    Photo.where{location_id.eq(nil)}.each do |photo|
      UtilLocator.perform_later photo.id
    end
  end

  def map_url
    if self.map_image_id == nil
      "api/photofiles/1/photoserve"
    else
      "api/photofiles/#{self.map_image_id}/photoserve"
    end
  end

  def get_google_map(zoom=10, size="350x300")
    marker = "#{self.latitude}%2C#{self.longitude}"
    return "http://maps.google.com/maps/api/staticmap?size=#{size}&sensor=false&zoom=#{zoom}&markers=#{marker}"
  end

  def self.no_location
    Rails.cache.fetch("no_location", expires_in: 12.hours) do
      return get_no_location
    end
  end

  def self.typeahead_search(query)
    match  = Location.where("address LIKE ?", "%#{query}%").select('id, address')
    n = match.map do |e|
      {:id=> e.id, :value=>e.address}
    end

    return n
  end

  def get_location
    self.geocoder_lookup
  end

  def coordinate_string
    self.latitude.to_s + "," + self.longitude.to_s
  end

  def geocoder_lookup
    if geo_location = Geocoder.search(self.coordinate_string).first
      if geo_location.data["error"].blank?
        self.country = geo_location.country
        self.city = geo_location.city
        self.suburb = geo_location.suburb
        self.postcode = geo_location.postal_code
        self.address = geo_location.address
        self.state = geo_location.state
        self.longitude = geo_location.longitude
        self.latitude = geo_location.latitude
      end
    end
  end

  private
  # def self.no_coordinates()
  #   if @photo.latitude.blank? || @photo.longitude.blank?
  #     @photo.location = get_no_location
  #     return true
  #   end
  # end
  #
  # def self.reuse_location()
  #   similar_locations = @photo.nearbys(1).where.not(location_id: nil)
  #   if similar_locations.count(:all) > 0
  #     @photo.location = similar_locations.first.location
  #     return true
  #   end
  # end

  # def self.geosearch
  #
  #   begin
  #     if geo_location = Geocoder.search(@photo.coordinate_string).first
  #       if geo_location.data["error"].blank?
  #         new_location = Location.new
  #         new_location.country = geo_location.country
  #         new_location.city = geo_location.city
  #         new_location.suburb = geo_location.suburb
  #         new_location.postcode = geo_location.postal_code
  #         new_location.address = geo_location.address
  #         new_location.state = geo_location.state
  #         new_location.longitude = geo_location.longitude
  #         new_location.latitude = geo_location.latitude
  #         new_location.save
  #         @photo.location = new_location
  #         return true
  #       else
  #         @photo.location = temp_location
  #       end
  #     else
  #       @photo.location = temp_location
  #     end
  #   rescue Exception => e
  #     @photo.location = temp_location
  #   end
  # end


  def self.get_no_location
    loc = Location.where(status:100)
    if loc.length > 0
      return loc.first
    else
      loc = Location.create(latitude:0, longitude:0, country:"N/A", status:100)
      return loc
    end
  end

  # def self.temp_location
  #   loc = Location.where(status:200)
  #   if loc.length > 0
  #     return loc.first
  #   else
  #     loc = Location.create(latitude:0, longitude:0, country:"N/A", status:200)
  #     return loc
  #   end
  # end


end
