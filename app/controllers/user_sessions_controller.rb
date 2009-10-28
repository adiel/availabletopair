class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = "Successfully logged in."
        redirect_to root_url
      else
        @user_session.errors.each do |attr,message|
          puts "Error: #{attr.inspect}: #{message}"
          if (attr == 'openid_identifier' and message == 'did not match any users in our database, have you set up your account to use OpenID?')
            #@user_session.errors.clear
            redirect_to new_user_url + "?openid_identifier=" + params["openid1_claimed_id"]
            return
          end
        end
        render :action => 'new'
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end