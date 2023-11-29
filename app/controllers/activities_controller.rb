class ActivitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @categories = Category.take(5)
    @activities_first_category = Activity.take(5)
    @activities_second_category = Activity.take(5)
    @activities_third_category = Activity.take(5)
    @activities_fourth_category = Activity.take(5)
    @activities_fifth_category = Activity.take(5)
  end

  def show
    @activity = Activity.find(params[:id])
  end
end
