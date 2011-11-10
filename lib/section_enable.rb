require 'net/ssh'

HOST = 'bbdev1.csuchico.edu'
USER = 'bbuser'

module SectionEnable

  def enable_section(section)
    type = 'enable'
    ssh_call(section,type)
  end

  def disable_section(section)
    type = 'disable'
    ssh_call(section,type)
  end
  
private


  def perl_script_parameters
      exec_string = "enable_disable.pl --id \"#{section.course_id}\" --externalID "
      exec_string += "\"#{section.batch_uid}\" --name \"#{section.course_name}\" "
      exec_string += "--state \"#{type}\" --dsk \"#{section.datasource}\""
  end
  
  def script_location
    '/h/a/TECH_STUFF/utility/enabledisable'
  end
  
  def executable_string
    script_location + " " + exec_string
  end
  
  def ssh_call(section,type)
    Net::SSH.start(HOST, USER, :password => "atec!d1rn") do |ssh|

      stdout = String.new

      ssh.exec!(executable_string) do |channel, stream, data|
        stdout << data if stream == :stdout
      end

      puts stdout
    end
  end

end

