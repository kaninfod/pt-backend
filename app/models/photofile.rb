class Photofile < ActiveRecord::Base
  attr_accessor :data, :url, :datahash, :phash
  before_create :import
  before_destroy :_delete

  PATH = Rails.configuration.phototank["filestorepath"]

  def import
    case self.data[:filetype]
    when "date"
      dh = _datehash(self.data[:date])
      filename = "#{dh[:datestring]}_#{self.data[:size]}_#{dh[:unique]}.jpg"
      path = File.join(PATH, dh[:year].to_s, dh[:month].to_s, dh[:day].to_s)
      self.size = self.data[:size]
    else
      filename = [*'a'..'z', *'A'..'Z', *0..9].shuffle.permutation(15).next.join
      path = File.join(PATH, self.data[:filetype])
    end

    FileUtils.mkdir_p File.join(path)
    filepath = File.join(path, filename)
    FileUtils.cp self.data[:path], filepath

    self.filetype = self.data[:filetype]
    self.path = filepath
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

  def _datehash(date)
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

  def _delete
    FileUtils.rm self.path if File.exists? self.path
  end
end
