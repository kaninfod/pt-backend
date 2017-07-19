class Location < ActiveRecord::Base
  validates :latitude, :longitude, :country, presence: true
  has_many :photos
  belongs_to :country
  belongs_to :city
  reverse_geocoded_by :latitude, :longitude

  def self.geolocate
    Photo.where{location_id.eq(nil)}.each do |photo|
      UtilLocator.perform_later photo.id
    end
  end

  def map_url
    if self.map_image_id == nil
      id = Setting.generic_image_md_id
      "/api/photofiles/#{id}/photoserve"
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
        self.country = Country.find_or_create_by(name: geo_location.country)
        self.city = City.find_or_create_by(name: geo_location.city)
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

  def self.get_no_location
    loc = Location.where(status:100)
    if loc.length > 0
      return loc.first
    else
      loc = Location.create(
        latitude:0,
        longitude:0,
        country:Country.find_or_create_by(name: "N/A"),
        city:City.find_or_create_by(name: "N/A"),
        status:100
      )
      return loc
    end
  end

end
