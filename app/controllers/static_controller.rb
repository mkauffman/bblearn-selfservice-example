class StaticController < ApplicationController


  def index
    @html = Tlp.find(:first, :conditions=>"html_type = 'migrate_contnt_html'").html
  end
  
end

