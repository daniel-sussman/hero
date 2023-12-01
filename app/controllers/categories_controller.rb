class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @activities = Activity.joins(activity_categories: :category).where("activity_categories.category_id = #{params[:id]}")
    @search_activities = Activity.joins(activity_categories: :category).where("activity_categories.category_id = #{params[:id]}")
    if params[:query].present?
      @search_activities = Activity.where(title: params[:query])
    end
  end
end
