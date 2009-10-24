class AvailabilitiesController < ApplicationController
  # GET /availabilities
  # GET /availabilities.xml
  def index
    @availabilities = Availability.find(:all, :order => "start_time",
                                              :conditions => ["end_time > :end_time",
                                                             {:end_time => Time.now.utc}])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @availabilities }
    end
  end

  # GET /availabilities/1
  # GET /availabilities/1.xml
  def show
    @availability = Availability.find(params[:id])
    @availability.pairs.sort! {|p1,p2| p1.updated_at <=> p2.updated_at}.reverse!

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @availability }
    end
  end
  
  # GET /availabilities/new
  # GET /availabilities/new.xml
  def new
    @availability = Availability.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @availability }
    end
  end

  # GET /availabilities/1/edit
  def edit
    @availability = Availability.find(params[:id])
  end

  # POST /availabilities
  # POST /availabilities.xml
  def create
    @availability = Availability.new(params[:availability])

    respond_to do |format|
      if @availability.save
        flash[:notice] = 'Availability was successfully created.'
        format.html { redirect_to(@availability) }
        format.xml  { render :xml => @availability, :status => :created, :location => @availability }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @availability.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /availabilities/1
  # PUT /availabilities/1.xml
  def update
    @availability = Availability.find(params[:id])

    respond_to do |format|
      if @availability.update_attributes(params[:availability])
        flash[:notice] = 'Availability was successfully updated.'
        format.html { redirect_to(@availability) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @availability.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.xml
  def destroy
    @availability = Availability.find(params[:id])
    @availability.destroy

    respond_to do |format|
      format.html { redirect_to(availabilities_url) }
      format.xml  { head :ok }
    end
  end
end
