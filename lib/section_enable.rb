require 'net/ssh'

HOST = 'bbdev1.csuchico.edu'
USER = 'bbuser'
LD_PATH = 'LD_LIBRARY_PATH=/opt/oracle/product/11.2.0.2/liblib'
   

module SectionEnable

  def enable_section(section)
    @section  = section
    @type     = 'enable'
    ssh_call
  end

  def disable_section(section)
    @section  = section
    @type     = 'disable'
    ssh_call
  end
  
private

  def perl_script_parameters
    exec_string = "enable_disable.pl --id \"#{@section.course_id}\" --externalID "
    exec_string += "\"#{@section.batch_uid}\" --name \"#{@section.course_name}\" "
    exec_string += "--state \"#{@type}\" --dsk \"#{@section.datasource.batch_uid}\""
  end
  
  def script_location
    '/h/a/TECH_STUFF/utility/enabledisable/'
  end
  
  def executable_string
    script_location + perl_script_parameters
  end
  
  def ssh_call
    Net::SSH.start(HOST, USER, :password => "atec!d1rn") do |ssh|

      stdout = String.new
      
      shell = ssh.shell.sync
   
      ssh.exec!(executable_string) do |channel, stream, data|
        stdout << data
      end

      puts stdout
    end
  end

end

