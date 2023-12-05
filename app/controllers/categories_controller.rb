class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @categories = Category.all
    @page_category = true
  end

  def show
    @category = Category.find(params[:id])
    @activities = Activity.joins(activity_categories: :category).where("activity_categories.category_id = #{params[:id]}")
    if params[:query].present?
      @search_activities = @search_activities.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

  def category_index
    @category = Category.find(params[:id])
    @activities = Activity.joins(activity_categories: :category).where("activity_categories.category_id = #{params[:id]}")
    if params[:query].present?
      @activities = @activities.where("title ILIKE ?", "%#{params[:query]}%")
    end
    render :show
  end

end
