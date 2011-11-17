require 'net/ssh'
require 'rye'

HOST = 'bbdev1.csuchico.edu'
USER = 'bbuser'
LD_PATH = 'LD_LIBRARY_PATH=/opt/oracle/product/11.2.0.2/lib'
   

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
    exec_string = "enable_disable.pl --id #{@section.course_id} --externalID "
    exec_string += "#{@section.batch_uid} --name #{@section.course_name} "
    exec_string += "--state #{@type} --dsk #{@section.datasource.batch_uid}"
  end
  
  def script_location
    '/h/a/TECH_STUFF/utility/enabledisable/'
  end
  
  def executable_string
    script_location + perl_script_parameters
  end
  
  def ssh_call
    begin
      Rye::Cmd.add_command :enable_disable, executable_string
      rbox = Rye::Box.new(HOST, {:user => USER,:password => "atec!d1rn"})
      rbox.setenv('LD_LIBRARY_PATH', '/opt/oracle/product/11.2.0.2/lib')
      rbox.enable_disable
    rescue
    end
  end
  
  def old_call
    Net::SSH.start(HOST, USER, :password => "atec!d1rn") do |ssh|

      stdout = String.new
      
      
      ssh.exec! "export LD_LIBRARY_PATH=/opt/oracle/product/11.2.0.2/lib"
      ssh.exec!(executable_string) do |channel, stream, data|
        stdout << data
      end

      puts stdout
    end
  end

end

