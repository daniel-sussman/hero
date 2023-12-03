class ActivitiesController < ApplicationController
  before_action :set_encounter, only: %i[like attended rating save click fewer]
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @categories = Category.take(5)
    @categories_all = Category.all
    @all_recommended_activities = Activity.geocoded.take(25)
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
    @coords = [current_user.latitude, current_user.longitude] if user_signed_in? #replace default coords with IP address coords

    @markers = @all_recommended_activities.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_card_html: render_to_string(partial: "info_card", locals: { activity: activity }),
        marker_html: render_to_string(partial: "marker_#{color_code(activity)}")
      }
    end
    @home_marker = render_to_string(partial: "marker_home")
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def like
    @encounter.update(liked: !@encounter.liked)
  end

  def attended
    @encounter.update(attended: true)
  end

  def rating
    @encounter.update(rating: params[:rating].to_i)
  end

  def save
    @encounter.update(saved: !@encounter.saved)
  end

  def click
    @encounter.update(clicked_on: true)
  end

  def fewer
    @encounter.update(show_me_fewer: !@encounter.show_me_fewer)
  end

  private

  def set_encounter
    @encounter = Encounter.find_by(activity_id: params[:id], user_id: current_user.id)
  end

  def color_code(_activity)
    #to-do: color code by category
    "green"
  end
end
