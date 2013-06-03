class UsersController < ApplicationController
 
  private

  def sort_availabilities_and_pairs
    @availabilities.each do |availability|
      availability.sort_pairs_by_matching_tag_count_and_updated_at_desc
    end
    @availabilities.sort! do |a1, a2|
      a1_updated = a1.pairs.length == 0 ? a1.updated_at : a1.pairs[0].updated_at
      a2_updated = a2.pairs.length == 0 ? a2.updated_at : a2.pairs[0].updated_at
      a1_updated <=> a2_updated
    end.reverse!
  end

  public

  # GET /username
  # GET /username.atom
  def index
    @user = User.find(:all,:conditions => {:username => params[:id]})[0]
    if @user.nil?
      redirect_to root_url
      return
    end

    @availabilities = Availability.find(:all,
                                        :conditions => ["user_id = :user_id",
                                                        {:user_id => @user.id}])

    @availabilities = Availability.filter_by_start_and_end_date!(@availabilities,params)

    respond_to do |format|
      sort_availabilities_and_pairs
      render_args = Availability.render_args
      format.html # new.html.erb
      format.xml {render :xml => @availabilities.to_xml(render_args)}
      format.js {render :json => @availabilities.to_json(render_args)}
      format.atom
    end
  end

  def new
    @user = User.new
    @user.openid_identifier = params[:openid_identifier]    
  end

  def create
    @user = User.create(params[:user])
    @user.confirm!
    @user.save do |result|
      if result
        flash[:notice] = "Registration successful."
        redirect_to root_url
      else
        render :action => 'new'
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    username = current_user.username
    @user.attributes = params[:user]
    @user.username = username     
    @user.save do |result|
      if result
        flash[:notice] = "Successfully updated profile."
        redirect_to root_url
      else
        render :action => 'edit'
      end
    end
  end
end
