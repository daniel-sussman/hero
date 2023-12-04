class SearchesController < ApplicationController

  def index
    #search_function
    @search_activities = Activity.all
    if params[:query].present?
      @search_activities = @search_activities.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

end
