class UsersController < ApplicationController
  def show
    if params[:id] == "sign_out"
      redirect_to activities_path
    else
      @user = current_user
      @collection = Collection.where("user_id = #{@user.id}")
    end
  end
end
