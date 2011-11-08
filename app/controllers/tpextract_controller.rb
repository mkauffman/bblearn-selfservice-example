require 'rexml/document'

class TpextractController < ApplicationController

include REXML
  def index
        @section_roles = SectionRole.find(:all,
        :conditions =>
        ['users_pk1 = :users_pk1 and role = :role', {:users_pk1 => session[:users_pk1], :role => 'P'}])
  end

  def user_tp
      @section          = Section.find(params[:id])
      @section_roles    = SectionRole.find(:all,
        :conditions =>
        ['crsmain_pk1 = :id and role = :role', {:id => params[:id], :role => 'S'}])

      send_data(xml_data, :type => "application/tpl", :filename => @section.course_id.to_s + ".tpl")

  end



private

  def xml_data
    file = File.new("doc/xml_header.xml")
    doc = Document.new(file)

    participants = doc.root.add(Element.new('participants'))
    participants.attributes["count"] = @section_roles.size

    count = 1

    @section_roles.each do |s|
      participant = Element.new "participant"
      participant.attributes["count"] = count

      participant.add_element "lastname"
      participant.elements["lastname"].text = s.user.lastname

      participant.add_element "firstname"
      participant.elements["firstname"].text = s.user.firstname

      participant.add_element "WebCT_ID"
      participant.elements["WebCT_ID"].text = s.user.user_id

      unless s.user.clicker.nil?
        participant.add_element "Device_ID"
        participant.elements["Device_ID"].text = s.user.clicker.resp_device_id
      end

      participants.add_element participant

      count = count + 1
    end
    return doc.to_s
  end
end

