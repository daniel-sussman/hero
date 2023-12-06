class CollectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :add_activity]
  def index
    if !current_user
      redirect_to root_path
      return
    end
    @page_collection = true
    @collections = current_user.collections
    @activities = Activity.where(id: current_user.encounters.where(saved: true).pluck(:activity_id).uniq)
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

    if params[:query].present?
      @collections = @collections.where("title ILIKE ?", "%#{params[:query]}%")
    end

    respond_to do |format|
      format.html
      format.text{render partial: "./views/collections/collection_cards", locals: {collection: @collection}, formats: [:html]}
    end
  end

  def show
    @collection = Collection.find(params[:id])
    if @collection.title.downcase == "all saved activities" && @collection.user == current_user
      @activities = Activity.where(id: current_user.encounters.where(saved: true).pluck(:activity_id).uniq)
    else
      @activities = @collection.activities
    end

    if params[:query].present?
      @search_activities = @activities.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.user = current_user
    if @collection.save
      redirect_to collections_path, notice: 'You created a new collection.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @collection.update(collection_params)

    respond_to do |format|
      format.html
      format.text{render partial: "collections/collection_infos", locals: {collection: @collection}, formats: [:html]}
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_path, notice: 'Collection was successfully deleted.', status: :see_other
  end

  def add_activity
    return if EncounterCollection.find_by(collection_id: @collection.id, encounter_id: params[:encounter_id])

    # remove activity from any of the user's other collections
    current_user.collections.each do |collection|
      EncounterCollection.find_by(collection_id: collection.id, encounter_id: params[:encounter_id])&.destroy
    end

    EncounterCollection.create(collection_id: @collection.id, encounter_id: params[:encounter_id])
  end

  def remove_activity
    current_user.encounter_collections.find_by(encounter_id: params[:encounter_id])&.destroy
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:title)
  end
end
