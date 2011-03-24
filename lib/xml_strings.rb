module Xml_strings
  ######################################### XML Strings ###########################################
  # Summary of string methods:                                                                    #
  # open_xml                                                                                      #
  # close_xml                                                                                     #
  # group_add_open                                                                                #
  # group_delete_open                                                                             #
  # group_update_open                                                                             # 
  # group_close                                                                                   #
  # person_add_open                                                                               #
  # person_update_open                                                                            #
  # person_delete_open                                                                            #
  # person_close                                                                                  #
  # membership_open                                                                               #
  # membership_close                                                                              #
  # member_open                                                                                   #
  # member_close                                                                                  #
  # properties                                                                                    #
  # sourced_id                                                                                    #
  # parent_sourced_id                                                                             #
  # person_sourced_id                                                                             #
  # group_type                                                                                    #
  # description                                                                                   #
  # timeframe                                                                                     #
  # enrollcontrol                                                                                 #
  # datasource                                                                                    #
  # parent_relationship                                                                           #
  # term_relationship                                                                             #
  # role_add_primary_instructor                                                                   #
  # role_add_designer                                                                             #
  # role_add_student                                                                              #
  # role_update_instructor                                                                        #
  # role_update_designer                                                                          #
  # role_update_student                                                                           #
  # role_remove_instructor                                                                        #
  # role_remove_designer                                                                          #
  # role_remove_student                                                                           #
  # section_add_role                                                                              #
  # section_update_role                                                                           #
  # section_remove_role                                                                           #
  # section_id_type                                                                               #
  # person_id_type                                                                                #
  # user_id                                                                                       #    
  # name                                                                                          #
  # extension                                                                                     #
  def self.open_xml(object)
    xml = <<__XML__
<?xml version="1.0" encoding="UTF-8"?>
<enterprise xmlns:webct="http://www.webct.com/IMS">
  <properties>
    <datasource>DATASOURCE</datasource>
    <datetime>DATETIME</datetime>
  </properties>
__XML__
    
    #unless (object.datasource.nil?)
    #  xml = xml.gsub(/DATASOURCE/, object.datasource)
    #else
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    #end # unless section
    t = Time.now
    datetime = t.strftime("%Y-%m-%d_%H%M")
    xml = xml.gsub(/DATETIME/, datetime)
    
    return xml
  end # open_xml
  
  def self.close_xml
    return "</enterprise>"
  end # close_enterprise_xml
  
  def self.group_add_open
    return "<group>"
  end # group_add_open
  
  def self.group_delete_open
    return "<group recstatus=\"3\">"
  end # group_delete_open
  
  def self.group_update_open
    return "<group recstatus=\"2\">"
  end # group_delete_open
  
  def self.group_close
    return "</group>"
  end # group_close
  
  def self.person_add_open
    return "<person recstatus=\"1\">"
  end # person_add_open
  
  def self.person_update_open
    return "<person recstatus=\"2\">"
  end # person_update_open
  
  def self.person_delete_open
    return "<person recstatus=\"3\">"
  end # person_delete_open
  
  def self.person_close
    return "</person>"
  end # person_close
  
  def self.membership_open
    return "<membership>"
  end # membership_open
  
  def self.membership_close
    return "</membership>"
  end # membership_close
  
  def self.member_open
    return "<member>"
  end # member_open
  
  def self.member_close
    return "</member>"
  end # member_close
  
  def self.properties(object)
    xml = <<__XML__
<properties>
  <datasource>DATASOURCE</datasource>
  <datetime>DATETIME</datetime>
</properties>
__XML__
    
    #unless (object.datasource.nil?)
    #  xml = xml.gsub(/DATASOURCE/, object.datasource)
    #else
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    #end # unless section
    t = Time.now
    datetime = t.strftime("%Y-%m-%d_%H%M")
    xml = xml.gsub(/DATETIME/, escape(datetime))
  end # properties
  
  def self.sourced_id(section)
    xml = <<__XML__
<sourcedid>
  <source>SOURCE</source>
  <id>ID</id>
</sourcedid>
__XML__
    
    #xml = xml.gsub(/SOURCE/, "CSU Chico - CMS")
    xml = xml.gsub(/SOURCE/, section.source)
    xml = xml.gsub(/ID/, escape(section.section_id))
    return xml
  end # sourced_id
  
  def self.parent_sourced_id(section)
    xml = <<__XML__
<sourcedid>
  <source>SOURCE</source>
  <id>ID</id>
</sourcedid>
__XML__
    
    xml = xml.gsub(/SOURCE/, section.parent_source)
    #xml = xml.gsub(/SOURCE/, "CSU Chico - CMS")
    xml = xml.gsub(/ID/, escape(section.parent_id))
    return xml
  end # parent_sourced_id
  
  def self.person_sourced_id(person)
    xml = <<__XML__
<sourcedid>
  <source>SOURCE</source>
  <id>ID</id>
</sourcedid>
__XML__
    
    xml = xml.gsub(/SOURCE/, person.source)
    #xml = xml.gsub(/SOURCE/, "CSU Chico - CMS")
    xml = xml.gsub(/ID/, escape(person.sourced_id.to_s))
    return xml
  end # person_sourced_id
  
  def self.grouptype(section)
    xml = <<__XML__
<grouptype>
  <scheme>LEARNING_CONTEXT_V1</scheme>
  <typevalue level="LEVEL"/>
</grouptype>
__XML__
    
    xml = xml.gsub(/LEVEL/, escape(section.level))
    return xml
  end # grouptype
  
  def self.description(section)
    xml = <<__XML__
<description>
  <short>SHORT</short>
  <long>LONG</long>
  <full>FULL</full>
</description>
__XML__
    
    xml = xml.gsub(/SHORT/, escape(section.short_name))
    xml = xml.gsub(/LONG/, escape(section.long_name))
    xml = xml.gsub(/FULL/, escape(section.full_name))
    return xml
  end # description
  
  def self.timeframe(section)
    xml = <<__XML__
<timeframe>
  <begin restrict="BEGIN_RES">BEGIN_DATE</begin>
  <end restrict="END_RES">END_DATE</end>
  <adminperiod>ADMIN_PER</adminperiod>
</timeframe>
__XML__
    
    if section.timeframe_restrict_begin.nil? or section.timeframe_begin.nil? or 
      section.timeframe_restrict_end.nil? or section.timeframe_end.nil?
      xml = xml.gsub(/<begin restrict="BEGIN_RES">BEGIN_DATE<\/begin>/, "")
      xml = xml.gsub(/<end restrict="END_RES">END_DATE<\/end>/, "")
    else
      xml = xml.gsub(/BEGIN_RES/, escape(section.timeframe_restrict_begin))
      xml = xml.gsub(/BEGIN_DATE/, escape(section.timeframe_begin.to_s))
      xml = xml.gsub(/END_RES/, escape(section.timeframe_restrict_end))
      xml = xml.gsub(/END_DATE/, escape(section.timeframe_end.to_s))
    end # if section timeframe nil
    xml = xml.gsub(/ADMIN_PER/, escape(section.admin_period))
    return xml
  end # timeframe
  
  def self.enrollcontrol(section)
    xml = <<__XML__
<enrollcontrol>
  <enrollaccept>ENROLL</enrollaccept>
</enrollcontrol>
__XML__
    
    xml = xml.gsub(/ENROLL/, escape(section.accept_enrollment))
    return xml
  end # enrollcontrol
  
  def self.parent_relationship(section)
    xml = <<__XML__
<relationship relation="1">
  <sourcedid>
    <source>SOURCE</source>
    <id>ID</id>
  </sourcedid>
  <label/>
</relationship>
__XML__
    
    xml = xml.gsub(/SOURCE/, section.parent_source)
    #xml = xml.gsub(/SOURCE/, "CSU Chico - CMS")
    xml = xml.gsub(/ID/, escape(section.parent_id))
    return xml
  end # parent_relationship
  
  def self.term_relationship(section)
    xml = <<__XML__
<relationship relation="1">
  <sourcedid>
    <source>SOURCE</source>
    <id>ID</id>
  </sourcedid>
  <label>Term</label>
</relationship>
__XML__
    
    #xml = xml.gsub(/SOURCE/, section.term_datasource)
    xml = xml.gsub(/SOURCE/, "CSU Chico - CMS")
    xml = xml.gsub(/ID/, escape(section.term_id))
    return xml
  end # term_relationship
  
  def self.datasource(section)
    xml = <<__XML__
<datasource>DATASOURCE</datasource>
__XML__
    
    #unless (section.datasource.nil?)
    #  xml = xml.gsub(/DATASOURCE/, section.datasource)
    #else
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    #end # unless section
    return xml
  end # datasource
  
  def self.role_add_primary_instructor(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="1" roletype="02">
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    unless (person.datasource.nil?)
      xml = xml.gsub(/DATASOURCE/, escape(person.datasource))
    else
      xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    end # unless section
    return xml
  end # role_add_primary_instructor
  
  def self.role_add_guest_instructor(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="1" roletype="02">
  <subrole>Subordinate</subrole>
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    unless (person.datasource.nil?)
      xml = xml.gsub(/DATASOURCE/, escape(person.datasource))
    else
      xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    end # unless section
    return xml
  end
  
  def self.role_add_designer(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="1" roletype="03">
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_add_designer
  
  def self.role_add_student(person, *status)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="1" roletype="01">
  <status>STATUS</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    if (status == "inactive"): xml = xml.gsub(/STATUS/, "0") else xml = xml.gsub(/STATUS/, "1") end
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_add_student
  
  def self.role_update_instructor(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="2" roletype="02">
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    #xml = xml.gsub(/DATASOURCE/, person.datasource)
    return xml
  end # role_update_instructor
  
  def self.role_update_student(person, *status)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="2" roletype="01">
  <status>STATUS</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    if (status == "inactive"): xml = xml.gsub(/STATUS/, "0") else xml = xml.gsub(/STATUS/, "1") end
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    #xml = xml.gsub(/DATASOURCE/, person.datasource)
    return xml
  end # role_update_instructor
  
  def self.role_update_designer(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="2" roletype="03">
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_update_designer
  
  def self.role_remove_instructor(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="3" roletype="02">
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_remove_instructor
  
  def self.role_remove_student(person, *status)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="3" roletype="01">
  <status>STATUS</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    if (status == "inactive"): xml = xml.gsub(/STATUS/, "0") else xml = xml.gsub(/STATUS/, "1") end
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_remove_student
  
  def self.role_remove_designer(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="3" roletype="03">
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_remove_instructor
  
  def self.role_add_teaching_assistant(person, *status)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="1" roletype="02">
  <subrole>TA</subrole>
  <status>STATUS</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    if (status == "inactive"): xml = xml.gsub(/STATUS/, "0") else xml = xml.gsub(/STATUS/, "1") end
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_add_teaching_assistant
  
  def self.role_remove_teaching_assistant(person, *status)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="3" roletype="02">
  <subrole>TA</subrole>
  <status>STATUS</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    if (status == "inactive"): xml = xml.gsub(/STATUS/, "0") else xml = xml.gsub(/STATUS/, "1") end
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_add_teaching_assistant
  
  def self.role_add_auditor(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="1" roletype="01">
  <subrole>AUD</subrole>
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_add_auditor
  
  def self.role_remove_auditor(person)
    # recstatus "1" Add, "2" Update, "3" Delete
    # roletype "01" Student, "02" Instructor, "03" Designer
    # status is only for students, but all posts must have it, "0" inactive, "1" active
    
    xml = <<__XML__
<role recstatus="3" roletype="01">
  <subrole>AUD</subrole>
  <status>1</status>
  <userid>USERID</userid>
  <datasource>DATASOURCE</datasource>
</role>
__XML__
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    xml = xml.gsub(/DATASOURCE/, "CSU Chico - CMS")
    return xml
  end # role_remove_auditor
  
  def self.section_add_role
    xml = <<__XML__
<role recstatus="1">
  <status>1</status>
</role>
__XML__
  end # section_add_role
  
  def self.section_update_role
    xml = <<__XML__
<role recstatus="2">
  <status>1</status>
</role>
__XML__
  end # section_update_role
  
  def self.section_remove_role
    xml = <<__XML__
<role recstatus="3">
  <status>1</status>
</role>
__XML__
  end # section_remove_role
  
  def self.section_id_type
    # idtype indicates whether the <member> object is a person (idtype = "1") or a section (idtype = "2")
    xml = "<idtype>2</idtype>"
    
    return xml
  end # id_type
  
  def self.person_id_type
    # idtype indicates whether the <member> object is a person (idtype = "1") or a group (idtype = "2")
    xml = "<idtype>1</idtype>"
    
    return xml
  end # id_type
  
  def self.user_id(person)
    xml = "<userid>USERID</userid>"
    
    xml = xml.gsub(/USERID/, escape(person.webct_id))
    return xml
  end # user_id
  
  def self.name(person)
    xml = <<__XML__
<name>
  <fn>FULLNAME</fn>
  <n>
    <family>LAST</family>
    <given>FIRST</given>
  </n>
</name>
__XML__
    
    unless person.full_name.nil?
      xml = xml.gsub(/FULLNAME/, escape(person.full_name))
    else
      xml = xml.gsub(/FULLNAME/, escape(person.first_name)+" "+escape(person.last_name))
    end # unless full_name nil
    xml = xml.gsub(/LAST/, escape(person.last_name))
    xml = xml.gsub(/FIRST/, escape(person.first_name))
    return xml
  end # name
  
  def self.extension(section)
    xml = <<__XML__
<extension>
  <webct:template>
    <webct:sourcesection>
      <sourcedid>
        <source>SOURCE</source>
        <id>ID</id>
      </sourcedid>
    </webct:sourcesection>
  </webct:template>
</extension>
__XML__
    
    #xml = xml.gsub(/SOURCE/, escape(section.template_parent_source))
    xml = xml.gsub(/SOURCE/, "CSU Chico - CMS")
    xml = xml.gsub(/ID/, escape(section.template_parent_id))
  end # extension
  
  def self.escape(value)
    value = value.gsub(/"/, "&quot;")
    value = value.gsub(/'/, "&apos;")
    value = value.gsub(/</, "&lt;")
    value = value.gsub(/>/, "&gt;")
    value = value.gsub(/&/, "&amp;")
  end # escape
end # module XMLStrings