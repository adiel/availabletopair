class UsersController < ApplicationController
  layout 'availabilities'

  def sort_availabilities_and_pairs
    @availabilities.each do |availability|
      availability.pairs.sort!{ |p1, p2| p1.updated_at <=> p2.updated_at}.reverse!
    end
    @availabilities.sort! do |a1, a2|
      a1_updated = a1.pairs.length == 0 ? a1.updated_at : a1.pairs[0].updated_at
      a2_updated = a2.pairs.length == 0 ? a2.updated_at : a2.pairs[0].updated_at
      a1_updated <=> a2_updated
    end.reverse!
  end

  # GET /username
  # GET /username.atom
  def index
    @availabilities = Availability.find(:all,
                                        :order => "start_time",
                                        :conditions => ["developer = :developer and end_time > :end_time" ,
                                                        {:developer => params[:id],:end_time => Time.now.utc}])
    respond_to do |format|
      format.html # index.html.erb
      format.atom  do
          sort_availabilities_and_pairs
      end
    end
  end
end
