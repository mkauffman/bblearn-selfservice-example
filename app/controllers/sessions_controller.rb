class SessionsController < ApplicationController
  def act_as      
    params[:act_as].downcase!
    obo_user = User.find_by_user_id(params[:act_as])
    if obo_user.nil?
      redirect_to :controller => "static", :action => "portal_id_failure" and return
    else
      session[:obo_pk1]       = obo_user.pk1
      session[:on_behalf_of]  = obo_user.user_id
      redirect_to :controller => "application", :action => "index" and return
    end    
  end 
end