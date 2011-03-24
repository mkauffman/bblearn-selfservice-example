class SelfserviceController < ApplicationController
  def index
    begin
      @html = Tlp.find(:first, :conditions=>"html_type = 'contnt_html'").html
    rescue
    end
  end
  
  def act_as
    if ([:super, :admin, :tlp_admin, :tlp].include?(session[:role]))
      if Person.check_user_id_existence(params['act_as'])
        session[:on_behalf_of] = params['act_as']
        redirect_to :controller => "selfservice", :action => "index" and return
      else
        redirect_to :controller => "selfservice", :action => "portal_id_failure" and return
      end # if user
    else
      redirect_to :controller => "selfservice", :action => "index" and return
    end # if admin
  end # act_as
  
  def test_setup_form
    if [:super, :admin, :tlp_admin, :tlp].include?(session[:role])
    end # if allowed
  end # test_setup_form
  
  def test_setup_exec
    if [:super, :admin, :tlp_admin, :tlp].include?(session[:role])
      current_term = Term.find_current_term.last
      future_term = Term.find_future_terms.last
      tester = Person.find_person_by_webct_id(session[:user]).last
      student_1 = Person.find_person_by_webct_id(params[:student_1]).last
      student_2 = Person.find_person_by_webct_id(params[:student_2]).last
      ta = Person.find_person_by_webct_id(params[:ta]).last
      auditor = Person.find_person_by_webct_id(params[:auditor]).last
      init_guest = Person.find_person_by_webct_id(params[:init_guest]).last
      parent1 = Section.find_section_by_section_id("098-GEOG101-01-1451").last
      
      section = Section.new
      section.datasource = "CSU Chico - CMS"
      section.source = "CSU Chico - CMS"
      section.section_id = session[:user]+"-testcourse"
      section.short_name = "000 Test Regular Course "+session[:user]
      section.long_name = session[:user]+" Test Regular Course"
      section.full_name = ""
      section.term_id = current_term.term_id
      section.term_datasource = "CSU Chico - CMS"
      section.accept_enrollment = "1"
      section.parent_source = "CSU Chico - CMS"
      section.parent_id = "under_dev_selfservice"
      
      xml = Xml_strings.open_xml(section)
      xml += section.create_course
      
      section.section_id = session[:user]+"-testsection-regular"
      section.short_name = "001 Test Regular Section Selfservice"
      section.long_name = "001 Test Regular Section Selfservice"
      section.full_name = "001 Test Regular Section Selfservice"
      section.admin_period = current_term.term_id
      section.parent_id = session[:user]+"-testcourse"
      section.template_parent_id = parent1.section_id
      section.template_parent_source = parent1.source
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
      xml += student_1.add_student(section)
      xml += student_2.add_student(section)
      xml += ta.add_teaching_assistant(section)
      xml += auditor.add_auditor(section)
      xml += init_guest.add_designer(section)
      
      section.section_id = session[:user]+"-testsection-future1"
      section.short_name = "009 Test Future Section 1 Selfservice"
      section.long_name = "009 Test Future Section 1 Selfservice"
      section.full_name = "009 Test Future Section 1 Selfservice"
      section.term_id = future_term.term_id
      section.admin_period = future_term.term_id
      section.parent_id = session[:user]+"-testcourse"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
      
      section.section_id = session[:user]+"-testsection-future2"
      section.short_name = "010 Test Future Section 2 Selfservice"
      section.long_name = "010 Test Future Section 2 Selfservice"
      section.full_name = "010 Test Future Section 2 Selfservice"
      section.admin_period = future_term.term_id
      section.parent_id = session[:user]+"-testcourse"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
=begin      
      section.section_id = session[:user]+"-testsection-prep"
      section.short_name = "002 Test Prep Section Selfservice"
      section.long_name = "002 Test Prep Section Selfservice"
      section.full_name = "002 Test Prep Section Selfservice"
      section.admin_period = nil
      section.timeframe_end = nil
      section.timeframe_restrict_end = nil
      section.timeframe_begin = nil
      section.timeframe_restrict_begin = nil
      section.term_id = "preparea-term"
      section.admin_period = "preparea-term"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
      
      section.section_id = session[:user]+"-testsection-selfpaced"
      section.short_name = "003 Test Self Paced Section Selfservice"
      section.long_name = "003 Test Self Paced Section Selfservice"
      section.full_name = "003 Test Self Paced Section Selfservice"
      section.term_id = "selfpaced-term"
      section.admin_period = "selfpaced-term"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
      
      section.section_id = session[:user]+"-testsection-specialprojects"
      section.short_name = "004 Test Special Project Section Selfservice"
      section.long_name = "004 Test Special Project Section Selfservice"
      section.full_name = "004 Test Special Project Section Selfservice"
      section.term_id = "specialprojects-term"
      section.admin_period = "specialprojects-term"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
      
      section.section_id = session[:user]+"-testsection-testing"
      section.short_name = "005 Test Testing Section Selfservice"
      section.long_name = "005 Test Testing Project Section Selfservice"
      section.full_name = "005 Test Testing Project Section Selfservice"
      section.term_id = "testing-term"
      section.admin_period = "testing-term"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
      
      section.section_id = session[:user]+"-testsection-tlp"
      section.short_name = "006 Test TLP Section Selfservice"
      section.long_name = "006 Test TLP Section Selfservice"
      section.full_name = "006 Test TLP Section Selfservice"
      section.term_id = "tlp-term"
      section.admin_period = "tlp-term"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
      
      section.section_id = session[:user]+"-testsection-hidden"
      section.short_name = "007 Test Hidden Section Selfservice"
      section.long_name = "007 Test Hidden Section Selfservice"
      section.full_name = "007 Test Hidden Section Selfservice"
      section.term_id = "hidden-term"
      section.admin_period = "hidden-term"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)
=end
      
      section.section_id = session[:user]+"-testsection-group"
      section.short_name = "008 Test Group Section Selfservice"
      section.long_name = "008 Test Group Section Selfservice"
      section.full_name = "008 Test Group Section Selfservice"
      section.term_id = "group-term"
      section.admin_period = "group-term"
      
      xml += section.create_section
      xml += tester.add_primary_instructor(section)
      xml += tester.add_designer(section)

      xml += Xml_strings.close_xml
      
      @res = Xml_client.post(xml).body.content
      @course = Section.find_course_by_course_id(session[:user]+"-selfservice-testcourse").last
      @regular = Section.find_section_by_section_id(session[:user]+"-testsection-regular").last
      @future1 = Section.find_section_by_section_id(session[:user]+"-testsection-future1").last
      @future2 = Section.find_section_by_section_id(session[:user]+"-testsection-future2").last
    end # if allowed
  end # test_setup_exec
  
  def test_teardown
    if [:admin, :super, :tlp, :tlp_admin].include?(session[:role])
      regular = Section.find_section_by_section_id(session[:user]+"-testsection-regular").last
      #prep = Section.find_section_by_section_id(session[:user]+"-testsection-prep").last
      #selfpaced = Section.find_section_by_section_id(session[:user]+"-testsection-selfpaced").last
      #specialproject = Section.find_section_by_section_id(session[:user]+"-testsection-specialprojects").last
      #testing = Section.find_section_by_section_id(session[:user]+"-testsection-testing").last
      #tlp = Section.find_section_by_section_id(session[:user]+"-testsection-tlp").last
      #hidden = Section.find_section_by_section_id(session[:user]+"-testsection-hidden").last
      course = Section.find_course_by_course_id(session[:user]+"-testcourse").last
      group = Section.find_section_by_section_id(session[:user]+"-testsection-group").last
      future1 = Section.find_section_by_section_id(session[:user]+"-testsection-future1").last
      future2 = Section.find_section_by_section_id(session[:user]+"-testsection-future2").last
      
      xml = Xml_strings.open_xml(regular)
      xml += regular.delete_section
      #xml += prep.delete_section
      #xml += selfpaced.delete_section
      #xml += specialproject.delete_section
      #xml += testing.delete_section
      #xml += tlp.delete_section
      #xml += hidden.delete_section
      xml += group.delete_section
      xml += future2.delete_section
      xml += future1.delete_section
      xml += course.delete_course
      xml += Xml_strings.close_xml
      
      @res = Xml_client.post(xml).body.content
    end # if allowed
  end # test_teardown
  
  def problem
  end
  
  def permission
  end
  
  def portal_id_failure
  end
  
  def section_id_failure
  end
  
  def crosslist
  end

  def add_comm_problem
  end

  def add_comm_ppl_err
  end

  def nil_entry
  end

  def db_down
  end

  def tp_down
  end

  def http_problem
  end

  def csv_error
  end
end # controller selfservice