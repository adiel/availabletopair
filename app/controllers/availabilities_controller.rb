class AvailabilitiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show]

  public

  # GET /availabilities
  # GET /availabilities.xml
  def index
    @availabilities = Availability.find(:all, :order => "start_time",
                                              :conditions => ["end_time > :end_time",
                                                             {:end_time => Time.now.utc}])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @availabilities.to_xml(Availability.render_args)}
      format.js  { render :json => @availabilities.to_json(Availability.render_args)}
    end
  end

  # GET /availabilities/1
  # GET /availabilities/1.xml
  def show
    @availability = Availability.find(params[:id])
    @availability.sort_pairs_by_matching_tag_count_and_updated_at_desc

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @availability.to_xml(Availability.render_args)}
      format.js  { render :json => @availability.to_json(Availability.render_args)}
    end
  end
  
  # GET /availabilities/new
  def new
    @availability = Availability.new
  end

  def check_user_edit
    if current_user.id != @availability.user_id
      redirect_to root_url
      return false
    end
    true
  end

  # GET /availabilities/1/edit
  def edit
    @availability = Availability.find(params[:id])
    return unless check_user_edit
  end

  #TODO: unit tests
  def read_tags_from_params
    tags = []
    params[:availability][:tags].split(',').each do |text|
      existing_tag = Tag.find(:all, :conditions => {:tag => text})[0]
      tags.push existing_tag || Tag.new(:tag => text.strip)
    end
    params[:availability][:tags] = tags
  end

  # POST /availabilities
  def create
    read_tags_from_params
    @availability = Availability.new(params[:availability])
    @availability.user_id = current_user.id

    if @availability.save
      flash[:notice] = 'Availability was successfully created.'
      redirect_to(@availability)
    else
      render :action => "new"
    end
  end

  # PUT /availabilities/1
  def update
    @availability = Availability.find(params[:id])
    return unless check_user_edit
    
    # todo, could you hack in a diff user id here?
    read_tags_from_params
    if @availability.update_attributes(params[:availability])
      flash[:notice] = 'Availability was successfully updated.'
      redirect_to(@availability)
    else
      render :action => "edit"
    end
  end

  # DELETE /availabilities/1
  def destroy
    @availability = Availability.find(params[:id])
    return unless check_user_edit
    @availability.destroy

    redirect_to(availabilities_url)
  end

end
