class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_name_desc
    @shelters_apps_pending = Shelter.apps_pending
  end

  def show
    @shelter_sql = Shelter.get_name_with_sql(params[:id])
  end
end
