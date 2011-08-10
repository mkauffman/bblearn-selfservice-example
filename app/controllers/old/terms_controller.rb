class TermsController < ApplicationController
  before_filter do |c|
    c.send(:is_authorized, [:super, :admin])
  end
  
  def index
    # list the terms in the database
    @terms = Term.find_terms
  end # index
  
  def create
    # form to create a new term
  end # create
  
  def empty_params
    # error page when parameters submitted were empty or nil
  end # empty_params
  
  def term_exists_already
    # error page when a term already exists in the database
  end # term_exists_already
  
  def format_error
    # error page when a term_id or other parameter isn't formatted correctly
  end # format_error
  
  def doesnt_exist
    # error page for editing term, term didn't exist
  end # doesnt_exist
  
  def date_used
    # error page when trying to create a term that has dates already used
  end # date_used
  
  def delete_term
    if filter(params[:term_id])
      logger.info 'Delete self service term, user: '+session[:user]+', term: '+params[:term_id]
      # delete term
      term = Term.find_term_by_term_id(params[:term_id]).last
      response = term.delete
      
      unless (response == "0 rows deleted")
        redirect_to(:action => "index")
      else
        redirect_to(:action => "doesnt_exist")
      end
    else # filter complained
      redirect_to(:controller => "selfservice", :action => "problem") and return
    end # if filter passes
  end # delete_term
  
  def edit_term
    # edit term fields
    if filter(params[:term_id], params[:current], params[:description], params[:end_date], params[:start_date])
      if empty_param(params[:term_id], params[:current], params[:description], params[:end_date], params[:start_date])
        # filters make sure no tampering took place
      end # if empty_params
    end # if filter_input
  end # edit_term
  
  def edit
    # check if they clicked Cancel
    if submit_check(params[:commit])
      # check to see if one or more of the parameters are empty
      if empty_param(params[:term_id], params[:current], params[:description], params[:end_date], params[:start_date])
        # filter user input for bad characters
        if filter(params[:term_id], params[:current], params[:description], params[:end_date], params[:start_date])
          # check that the params are in the correct format
          if format_check
            # make sure the term being edited exists
            unless Term.find_term_by_term_id(params[:old_term_id]).empty?
              logger.info 'Edit self service term, user: '+session[:user]+', term: '+params[:term_id]
              # convert current to boolean for entry
              current = true
              if (params[:current].downcase=="true"): current = "true" else current = "false" end
              
              # if current is yes, change the currently marked semester(s) as not current
              if (params[:current].downcase=="true")
                Term.null_all_current_terms
              end # if current yes
              
              term = Term.find_term_by_term_id(params[:old_term_id]).last
              term.term_id = params[:term_id]
              term.start_date = params[:start_date]
              term.end_date = params[:end_date]
              term.description = params[:description]
              term.current_term = current
              term.update
              
              redirect_to(:action => "index")
            else # term doesn't exist
              redirect_to(:action => "doesnt_exist")  
            end # term nil
          end # unless format incorrect
        end # if filter
      end # unless params empty?
    end # if submit_check
  end # edit
  
  def new_term
    # create a new term from the entered parameters
    # check if they clicked Cancel
    if submit_check(params[:commit])
      # check to see if one or more of the parameters are empty
      if empty_param(params[:term_id], params[:current], params[:description], params[:end_date], params[:start_date])
        # filter user input for bad characters
        if filter(params[:term_id], params[:current], params[:description], params[:end_date], params[:start_date])
          # check that the params are in the correct format
          if format_check
            # check to see if a similar term already exists
            unless exists_check
              # check if the start or end date is in another term already
              if dates_check
                logger.info 'Create self service term, user: '+session[:user]+', term: '+params[:term_id]
                if (params[:current].downcase=="true"): current = "true" else current = "false" end
                
                # if current is yes, change the currently marked semester(s) as not current
                if (params[:current].downcase=="true")
                  Term.null_all_current_terms
                end # if current yes
                
                # enter the new term
                term = Term.new
                term.term_id = params[:term_id]
                term.description = params[:description]
                term.start_date = params[:start_date]
                term.end_date = params[:end_date]
                term.current_term = current
                term.create
                
                # get updated terms for displaying
                @terms = Term.find_terms
              end # if start end dates already used
            end # unless exists_check
          end # if format_check
        end # if filter
      end # if empty_param
    end # if submit
  end # new_term
  
  ######################################### Private Methods ############################################
  private
  def filter(*params)
    problem = false
    params = params.flatten
    for param in params
      reg_filter = Regexp.new('[^-_,@\s:A-Za-z0-9]')
      if reg_filter.match(param)
        problem = true
      end # if match
    end # for param
    if problem
      redirect_to(:controller => "selfservice", :action => "problem") and return
    else
      return true
    end # if problem
  end # filter
  
  def empty_param(*params)
    problem = false
    for param in params
      if (param.nil?) or (param.empty?)
        problem = true
      end # if param
    end # for param
    if problem
      redirect_to(:action => "index") and return
    else
      return true
    end # if problem
  end # empty_param
  
  def submit_check(commit)
    unless commit=="Add" or commit=="Remove" or commit=="Delete" or commit=="Submit" or commit=="Confirm"
      redirect_to(:action => "index") and return
    else
      return true
    end # unless commit
  end # submit_chk
  
  def format_check
    # check that the params are in the correct format
    term_id_reg = Regexp.new('2[0-2][0-9][0-9]-term$')
    date_reg = Regexp.new('20[0-3][0-9][0-1][0-9][0-3][0-9]$')
    unless (term_id_reg.match(params[:term_id]).nil?) or (date_reg.match(params[:start_date]).nil?) or
     (date_reg.match(params[:end_date]).nil?) or (params[:description].length > 40)
      return true
    else # match not nil
      redirect_to(:action => "format_error") and return
    end # unless reg match
  end # format_check
  
  def exists_check
    # check to see if a similar term already exists
    unless Term.check_terms_existence(params[:term_id], params[:start_date], params[:end_date])
      return false
    else # term exists
      redirect_to(:action => "term_exists_already") and return
    end # if term find
  end # exists_check
  
  def dates_check
    # check if the start or end date is in another term already
    terms = Term.find_terms
    terms.each do |term|
      range = (term.start_date..term.end_date)
      if (range === params[:start_date].to_i) or (range === params[:end_date].to_i)
        redirect_to(:action => "date_used") and return
      end # if range include start/end date
    end # terms each
  end # dates_check
end # terms controller
