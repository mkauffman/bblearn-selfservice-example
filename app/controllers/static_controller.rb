class StaticController < ApplicationController


  def index
    @html = Tlp.find_by_html_type("learn_contnt_html").html
  end
  
end

