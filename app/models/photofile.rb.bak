class Photofile < ActiveRecord::Base
  attr_accessor :data, :url, :datahash, :phash
  validates :path, presence: true
  before_create :import_file
  before_update :update_file
  before_destroy :delete_file

  PATH = Rails.configuration.x.photoserve["filestorepath"]

  def update_file
    begin
      FileUtils.cp self.data, self.path
      self.touch
    rescue Exception => e
      byebug
    end
  end

  def import_file
    begin
      if self.datahash.has_key? :date_taken
        if self.datahash.has_key? :photosize
          size = self.datahash[:photosize]
        else
          size = 'org'
        end
        dh = generate_datehash(self.datahash[:date_taken])
        path = File.join(PATH, dh[:year].to_s, dh[:month].to_s, dh[:day].to_s)
        #TODO change extension. Should come from mime
        filename = "#{dh[:datestring]}_#{self.datahash[:photosize]}_#{dh[:unique]}.jpg"
        self.size = size
        self.filetype = 'date'
      else
        if self.datahash.has_key? :filetype
          path = File.join(PATH, self.datahash[:filetype])
          self.filetype = self.datahash[:filetype]
        else
          path = File.join(PATH, 'system')
          self.filetype = 'system'
        end
        filename = [*'a'..'z', *'A'..'Z', *0..9].shuffle.permutation(15).next.join
      end

      FileUtils.mkdir_p File.join(path)
      filepath = File.join(path, filename)
      FileUtils.cp self.path, filepath
      self.path = filepath
    rescue Exception => e
      raise e
    end
  end

  def delete_file
    FileUtils.rm self.path if File.exists? self.path
  end

  def get_phash
      phash = Phashion::Image.new(self.path)
      phash = phash.fingerprint
      return phash
  end

  def rotate(degrees)
    begin
      MiniMagick::Tool::Convert.new do |convert|
        convert << self.path
        convert << "-rotate" << degrees
        convert << self.path
      end
    rescue Exception
      Rails.logger.warn "Photofile #{self.id} was not rotated!"
      return false
    end
  end
  private

  def generate_datehash(date)
    date = date.to_date
    datestring = date.strftime("%Y%m%d%H%M%S")
    unique = [*'a'..'z', *'A'..'Z', *0..9].shuffle.permutation(5).next.join

    datehash = {
      :datestring=>datestring,
      :unique=>unique,
      :year=>date.year,
      :month=>date.month,
      :day=>date.day
    }

    return datehash
  end

end
