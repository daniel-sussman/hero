class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
  end

  def show
    @game = Activity(params[:id])
  end
end
