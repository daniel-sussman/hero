class EncountersController < ApplicationController
  def create
    encounter = Encounter.new(encounter_params)
    encounter.save!
    raise
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
