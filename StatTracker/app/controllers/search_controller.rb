class SearchController < ApplicationController
def google_images
    params[:start] = params[:start].to_i
    @page_title = "Import image from Google"
    @google_images = GoogleImage.all(params[:keywords], params[:start])
  end
end