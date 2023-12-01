class SearchesController < ApplicationController
  def index
    @ = Movie.all
    if params[:query].present?
      @movies = @movies.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end
end
