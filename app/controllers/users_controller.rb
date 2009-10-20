class UsersController < ApplicationController
  layout 'availabilities'
  # GET /username
  # GET /username.atom
  def index
    @availabilities = Availability.find(:all,
                                        :order => "start_time",
                                        :conditions => ["developer = :developer and end_time > :end_time" ,
                                                        {:developer => params[:id],:end_time => Time.now.getgm}])
    respond_to do |format|
      format.html # index.html.erb
      format.atom  do
          @availabilities.sort! { |a1,a2| a1.updated_at <=> a2.updated_at}.reverse!
      end
    end
  end
end
