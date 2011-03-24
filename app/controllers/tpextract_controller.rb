class TpextractController < ApplicationController
  def index
    @terms = Term.find_sso_terms
    unless (params[:selected_term].nil?)
      @selected_term = Term.find_term_by_term_id(params[:selected_term]).last
    else
      @selected_term = Term.find_current_term.last
    end
    @no_xlist_sections = Section.find_non_xlisted_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], @selected_term.term_id)
    @xlist_sections = Section.find_xlisted_sections_by_primary_instructor_id_and_term_id(session[:on_behalf_of], @selected_term.term_id)
  end #index
  
  def no_students
  end # no_students
  
  def generateXML
    if empty_param(params[:source_id])
      if filter(params[:source_id])
        logger.info 'Generate TP XML, user: '+session[:user]+', on behalf of: '+session[:on_behalf_of]+', section: '+params[:source_id]
        section = Section.find_section_by_section_id(params[:source_id]).last
        students = Person.find_students(params[:source_id])
        
        date_stamp = Time.now.strftime("%Y_%m_%d_%H%M%S")
        file_name = section.section_id + "-" + date_stamp + ".tpl"
        
        outputXML = ""
        if students.length > 0
          outputXML << '<?xml version="1.0"?>'
          outputXML << '<participantlist plistversion="2008">'
          outputXML << '<headeritems count="5">'
          outputXML << '<item type="field">Last Name</item>'
          outputXML << '<item type="field">First Name</item>'
          outputXML << '<item type="field">Device ID</item>'
          outputXML << '<item type="field">WebCT ID</item>'
          outputXML << '<item type="field">WCT Person ID</item>'
          outputXML << '</headeritems>'
          outputXML << '<participants count="' + students.length.to_s + '">'
          for student in students
            student_reg = getClickerRegFromWebService(student.webct_id).strip
            outputXML << '<participant id="' + student_reg + '">'
            outputXML << "<lastname>" + student.last_name + "</lastname>"
            outputXML << "<firstname>" + student.first_name + "</firstname>"
            outputXML << '<custom name="WebCT ID">' + student.webct_id + "</custom>"
            outputXML << '<custom name="WCT Person ID">' + student.empl_id.to_s + "</custom>"
            outputXML << "</participant>"
          end # for student
          outputXML << "</participants>"
          outputXML << "</participantlist>"
          
          send_data(outputXML, :type => "application/x-download", :filename => file_name)
        else
          redirect_to(:action => "no_students") and return
        end # if students length > 0 
      end # if filter
    end # if empty_param
  end # generateXML
  
  ########################### PRIVATE METHODS ####################################
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
  
  def getClickerRegFromWebService(webct_id)
    clicker_reg = ""
    client = HTTPClient.new
    
    res = client.post(AppConfig.tp_extract_post_url, webct_id+"\r\n")
    if res.status != 200
      redirect_to(:controller => "selfservice", :action => "tp_down") and return
    end # if status not 200
    
    columns = res.body.content.split(",")
    if columns.length > 1
      clicker_reg = columns[1].strip
      return clicker_reg
    else
      return nil
    end # if columns.length
  end # getClickerRegFromWebService(webct_id)
end # class TpextractController
