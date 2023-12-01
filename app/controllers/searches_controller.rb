class SearchesController < ApplicationController
  def index
    #search_function
    @search_activities = Activity.all
    if params[:query].present?
      @search_activities = Activity.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

  def category_index
    @category = params[:category_id]
    @search_activities = Activity.joins(activity_categories: :category).where("activity_categories.category_id = #{params[:category_id]}")
    if params[:query].present?
      @search_activities = @search_activities.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end
end
