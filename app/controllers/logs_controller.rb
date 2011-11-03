class LogsController < ApplicationController
  include CasLogin
  #before_filter :check_permission

  def index
    @logs = []
    @logs[0], @logs[1], @logs[2] = false, false, false
    @logs[0] = true if File.file?('log/development.log') 
    @logs[1] = true if File.file?('log/staging.log')     
    @logs[2] = true if File.file?('log/production.log')
  end

  def development
    @log = File.new('log/development.log', 'r')
    render :log
  end

  def staging
    @log = File.new('log/staging.log', 'r')
    render :log
  end

  def production
    @log = File.new('log/production.log', 'r')
    render :log
  end

  private

  def check_permission
    if roles_comp :logs, session[:role]
      return true
    else
      redirect_to :controller => "application", :action => "not_allowed" and return false
    end
  end
end
