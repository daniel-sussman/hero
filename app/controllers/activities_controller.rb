class ActivitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @categories = Category.take(5)
    @categories_all = Category.all
    @all_recommended_activities = Activity.geocoded.take(7)
    @activities = []
    @categories.each do |_cat|
      @activities << Activity.all.sample(5)
    end

    #create encounters
    @all_recommended_activities.each do |activity|
      unless Encounter.where(user_id: current_user, activity_id: activity.id).length > 0
        Encounter.create(user_id: current_user, activity_id: activity.id)
      end
    end

    #geocoding
    @coords = user_signed_in? ? [current_user.latitude, current_user.longitude] : [51.508045, -0.128217] #replace default coords with IP address coords

    @markers = @all_recommended_activities.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_card_html: render_to_string(partial: "info_card", locals: { activity: activity }),
        marker_html: render_to_string(partial: "marker_#{color_code(activity)}")
      }
    end

    @search_activities = Activity.all
    if params[:query].present?
      @search_activities = Activity.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def like
    encounter = Encounter.find_by(activity_id: params[:id], user_id: current_user.id)
    encounter.update(liked: !encounter.liked)
  end

  def save

  end

  def click

  end

  private

  def color_code(_activity)
    #to-do: color code by category
    "green"
  end
end
