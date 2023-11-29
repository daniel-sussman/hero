class CollectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  def index
    @collections = Collection.all

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
    @activities = @collection.activities
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
    @colllection = Collection.find(params[:id])
    @collection.update(collection_params)

    respond_to do |format|
      format.html
      format.text{render partial: "./views/collections/collection_infos", locals: {collection: @collection}, formats: [:html]}
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_path, notice: 'Collection was successfully deleted.'
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:title)
  end
end
