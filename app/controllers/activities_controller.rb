class ActivitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @categories = Category.take(5)
    @all_recommended_activities = Activity.geocoded.take(7)
    @activities_first_category = Activity.take(5)
    @activities_second_category = Activity.take(5)
    @activities_third_category = Activity.take(5)
    @activities_fourth_category = Activity.take(5)
    @activities_fifth_category = Activity.take(5)

    #geocoding
    @coords = user_logged_in? ? [current_user.latitude, current_user.longitude] : [51.508045, -0.128217] #replace default coords with IP address coords

    @markers = @all_recommended_activities.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_card_html: render_to_string(partial: "info_card", locals: { activity: activity }),
        marker_html: render_to_string(partial: "marker_#{color_code(activity)}")
      }
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end
end

private

def color_code(activity)
  #to-do: color code by category
  "green"
end
