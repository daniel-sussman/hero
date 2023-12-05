class UsersController < ApplicationController
  def show
    @user = current_user
    @children = @user.children
    # raise
    @collection = Collection.where("user_id = #{@user.id}")
    @liked_activities = current_user.encounters.where(liked: true).order(updated_at: :desc)
  end

  def map
    @saved_activities = Activity.joins(:encounters).where(encounters: { user: current_user, saved: true })
    @coords = [current_user.latitude, current_user.longitude] if user_signed_in? #replace default coords with IP address coords

    @markers = @saved_activities.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_card_html: render_to_string(partial: "activities/info_card", locals: { activity: activity }),
        marker_html: render_to_string(partial: "activities/marker_#{activity.color_code}")
      }
    end
    @home_marker = render_to_string(partial: "activities/marker_home")
  end
end
