class CategoriesController < ApplicationController
  skip_before_action :authentification [:index]
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @activity = Activity.find(params[:id])
    @activities = Activity.joins(:activity_categories)
                  .joins(:categories)
                  .where(“activity_categories.category_id = categories.id”)
                  .select(“activities.name”)
  end
end
