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
     #geocoding
     @coords = [current_user.latitude, current_user.longitude] if user_signed_in? #replace default coords with IP address coords

     @markers = @activities.map do |activity|
       {
         lat: activity.latitude,
         lng: activity.longitude,
         info_card_html: render_to_string(partial: "activities/info_card", locals: { activity: activity }),
         marker_html: render_to_string(partial: "activities/marker_#{activity.color_code}")
       }
     end
     @home_marker = render_to_string(partial: "activities/marker_home")

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
