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

    saved_encounters = current_user.encounters.where(saved: true)

    @activities = Activity.where(id: saved_encounters.pluck(:activity_id).uniq)

    @coords = [current_user.latitude, current_user.longitude] if user_signed_in? #replace default coords with IP address coords

    @markers = @activities.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_card_html: render_to_string(partial: "activities/info_card", locals: { activity: activity }, formats: [:html]),
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

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.user = current_user
    if @collection.save
      respond_to do |format|
        format.html { redirect_to collections_path, notice: 'You created a new collection.' }
        format.json do
          render json: {
            html: render_to_string(partial: 'collections/collection_menu_option', locals: { collection: @collection }, formats: :html)
          }
        end
      end
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
      format.text{render partial: "collections/collection_folder", locals: {collection: @collection, name: @collection.title, encounters: @collection.encounters }, formats: [:html]}
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_path, notice: 'Collection was successfully deleted.', status: :see_other
  end

  def add_activity
    encounter_id = params[:encounter_id]
    encounter = Encounter.find(encounter_id)

    if EncounterCollection.find_by(collection_id: @collection.id, encounter_id: encounter_id)
      return render(json: {})
    end

    # remove activity from any of the user's other collections
    current_user.collections.each do |collection|
      EncounterCollection.find_by(collection_id: collection.id, encounter_id: encounter_id)&.destroy
    end

    EncounterCollection.create(collection_id: @collection.id, encounter_id: encounter_id)

    render json: {
      modal: render_to_string(partial: "activities/modal", locals: { encounter: encounter, activity: encounter.activity }, formats: [:html])
    }
  end

  def remove_activity
    current_user.encounter_collections.find_by(encounter_id: params[:encounter_id])&.destroy
  end

  def unsorted
    @activities = current_user.default_collection.map(&:activity)

    if params[:query].present?
      @search_activities = @activities.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:title)
  end
end
