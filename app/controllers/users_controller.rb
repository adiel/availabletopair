class UsersController < ApplicationController
  layout 'availabilities'
  # GET /username
  def index
    @availabilities = Availability.find(:all,
                                        :order => "start_time",
                                        :conditions => ["developer = :developer",
                                                        {:developer => params[:id]}])
  end
end
