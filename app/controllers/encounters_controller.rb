class EncountersController < ApplicationController
  def create
    unless Encounter.find_by(user_id: params[:user_id], activity_id: params[:activity_id])
      encounter = Encounter.new(encounter_params)
      encounter.save
    end
  end

  def update
  end

  def like

  end

  def save

  end
end

private

def encounter_params
  params.require(:encounter).permit(:user_id, :activity_id)
end
