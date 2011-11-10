class SessionsController < ApplicationController
  def act_as      
    params[:act_as].downcase!
    obo_user = User.find_by_user_id(params[:act_as])
    if obo_user.nil?
      redirect_to :controller => "static", :action => "portal_id_failure",
                  :portal_ids => params[:act_as] 
    else
      session[:obo_pk1]       = obo_user.pk1
      session[:on_behalf_of]  = obo_user.user_id
      redirect_to root_url
    end    
  end 
  
  def logout
    end_session
    redirect_to "https://cas.csuchico.edu/cas/logout?service=bblearn"
  end
  
private

  def end_session
    session[:user_object]   = nil
    session[:user]          = nil
    session[:users_pk1]     = nil
    session[:on_behalf_of]  = nil
    session[:obo_pk1]       = nil
  end
  
end