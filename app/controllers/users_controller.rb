class UsersController < ApplicationController
 
  private
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

  public
  # GET /username
  # GET /username.atom
  def index
    @user = User.find(:all,:conditions => ["username = :username",{:username => params[:id]}])[0]
    if @user.nil?
      redirect_to root_url
      return
    end
    @availabilities = Availability.find(:all,
                                        :order => "start_time",
                                        :conditions => ["user_id = :user_id and end_time > :end_time" ,
                                                        {:user_id => @user.id,:end_time => Time.now.utc}])
    respond_to do |format|
      format.html # new.html.erb
      format.atom  do
          sort_availabilities_and_pairs
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
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
    @user.attributes = params[:user]
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
