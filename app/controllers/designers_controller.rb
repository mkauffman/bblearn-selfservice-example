class DesignersController < ApplicationController
  
  def index
  end # index
  
  def register
    @register = BblContext.new.register_tool
  end # register
  
  def get_memberships
    @memberships = BblContext.new.get_memberships("@mcarlson13") # make session[:on_behalf_of] in the future
  end
  
  def create_course
    @create = BblCourse.new.create_course("ws_create_course_test_"+Time.now.strftime("%m_%d_%Y_%H_%M_%S"))
  end
  
  def get_user
    @user = BblUser.new.get_user("@mcarlson13")
  end
end # Designers
