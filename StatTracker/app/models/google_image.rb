class GoogleImage

  require 'json'
  require 'open-uri'
  require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  attr_accessor :thumbnail, :original, :name, :position

  def initialize(params)
    super()
    self.name = params[:name]
    self.thumbnail = params[:thumbnail]
    self.original = params[:original]
    self.position = params[:position]
  end

  def self.find (keyword)
    url = "https://ajax.googleapis.com/ajax/services/search/images??v=1.0&q=#{CGI.escape(keyword)}"
    json_results = open(url) {|f| f.read };
    results = JSON.parse(json_results)
    image_array = results['responseData']['results']
    image = image_array[0] if image_array
    google_image = self.new(:thumbnail => image['tbUrl'], :original => image['unescapedUrl'], :position => position, :name => keyword.titleize)
  end

  def self.all (keyword)
    return [] if (keyword.nil? || keyword.strip.blank?)
    url = "https://ajax.googleapis.com/ajax/services/search/images??v=1.0&q=#{CGI.escape(keyword)}"
    json_results = open(url) {|f| f.read };
    results = JSON.parse(json_results)
    begin
      image_array = results['responseData']['results']
      google_images = image_array.map{|image| self.new(:thumbnail => image['tbUrl'], :original => image['unescapedUrl'], :name => keyword.titleize) }
      google_images.each_index{|i| google_images[i].position = position + i }
    rescue
      []
    end
  end

end