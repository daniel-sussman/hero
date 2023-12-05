class ActivitiesController < ApplicationController
  before_action :set_encounter, only: %i[like attended rating save click fewer]
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @page_activity = true

    if user_signed_in?
      @categories = current_user.categories
    else
      @categories = Category.take(5)
    end

    @activities = []
    @categories.each do |cat|
      @activities << Activity
        .joins(activity_categories: :category)
        .where("activity_categories.category_id = #{cat.id}")
        .algorithm_sort(current_user).first(5)
    end

    #populate the map with the activities shown in each category
    @all_recommended_activities = @activities.flatten

    #geocoding
    @coords = [current_user.latitude, current_user.longitude] if user_signed_in? #replace default coords with IP address coords

    @markers = @all_recommended_activities.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_card_html: render_to_string(partial: "info_card", locals: { activity: activity }),
        marker_html: render_to_string(partial: "marker_#{activity.color_code}")
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
end
