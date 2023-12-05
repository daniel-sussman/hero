class RegistrationsController < Devise::RegistrationsController
  def sign_up_params
    params.require(:user).permit(:name, :address, :latitude, :longitude,
      child_attributes: [:birthday])
  end
  def edit_params
    params.require(:user).permit(:name, :address, :latitude, :longitude,
      child_attributes: [:birthday])
  end
end
