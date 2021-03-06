class TagsController < ApplicationController

  public

  # GET /tags
  def index
    #Tag cloud?
  end

  # GET /tags/sometag
  # GET /tags/sometag.xml
  # GET /tags/sometag.js
  def show
	@tag = params[:id]
    @availabilities = Availability.find(:all, :order => :start_time, :include => :tags,
                                        :conditions => ['tags.tag = :tag and end_time > :end_time',
                                                       {:tag => @tag,:end_time => Time.now.utc}])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @availabilities.to_xml(Availability.render_args)}
      format.js  { render :json => @availabilities.to_json(Availability.render_args)}
      format.atom 
    end
  end
  
end
