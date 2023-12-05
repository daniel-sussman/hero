class ChildrenController < ApplicationController
  def destroy
    child = Child.find(params[:id])
    child.destroy
    head(:ok)
  end
end
