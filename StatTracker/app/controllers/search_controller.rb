class SearchController < ApplicationController
def google_images
    params[:start] = params[:start].to_i
    @page_title = "Import image from Google"
    @google_images = GoogleImage.all("Bob")
    puts "***********************************8"
    puts @google_images
  end
end