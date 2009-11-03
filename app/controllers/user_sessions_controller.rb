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
        if check_errors_for_new_openid
          redirect_to(new_user_url + "?openid_identifier=" + params["openid.identity"])
          return
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

  private

  def check_errors_for_new_openid()
    new_open_id = false
    @user_session.errors.each do |attr, message|
      if (attr == 'openid_identifier' &&
          message == 'did not match any users in our database, have you set up your account to use OpenID?')
        new_open_id = true
        break
      end
    end
    return new_open_id
  end
end
