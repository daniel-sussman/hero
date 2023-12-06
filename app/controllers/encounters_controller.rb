class EncountersController < ApplicationController
  def create
    @encounter = Encounter.new(encounter_params)
    @encounter.user = current_user

    if @encounter.save
      redirect_to @encounter.activity
    else
      render "activities/show", status: :unprocessable_entity
    end
  end

  def update
    @encounter = Encounter.find(params[:id])
    if @encounter.update(encounter_params)
      redirect_to @encounter.activity
    else
      render "activities/show", status: :unprocessable_entity
    end
  end
end

private

def encounter_params
  params.require(:encounter).permit(:user_id, :activity_id, :rating, :review)
end
