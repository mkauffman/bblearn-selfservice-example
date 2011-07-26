class SectionController < ApplicationController
  
  attr_accessor :term_id, :description, :start_date, :end_date, :current_term
  
  def initialize
    @term_id = '34'
    @description = "Mike's Mom's Mammaries"
    @start_date = '01011970'
    @end_date = '01021970'
    @current_term = '1'
  end
  
end