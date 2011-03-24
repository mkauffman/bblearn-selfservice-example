#! /usr/bin/env ruby

print "Are you testing staging [1] or production [2]? [1 or 2]: "
environment_number = gets.chomp
if environment_number == '1' or environment_number == '2'
  print "\r\nWhat is your self service username? "
  username = gets.chomp
  print "\r\nWhat is your self service password? "
  password = gets.chomp
  print "\r\nWhat is your vista admin username? "
  vista_username = gets.chomp
  print "\r\nWhat is your vista admin password? "
  vista_password = gets.chomp
  print "\r\nThe script will now replace the values in the tests to reflect your username and password"
  print "\r\nMake sure to run the reset script to wipe your personal information when your done testing.\r\n"
  
  username_reg = Regexp.new(/uname/)
  password_reg = Regexp.new(/pword/)
  vista_username_reg = Regexp.new(/vista_usname/)
  vista_password_reg = Regexp.new(/vista_paword/)
  if environment_number == '1'
    self_service_url_reg = /\/\/dlt.csuchico.edu/
    vista_url_reg = /\/\/vista.csuchico.edu/
    new_self_service_url = "//dlt-dev.csuchico.edu"
    new_vista_url = "//vista-staging.csuchico.edu"
  else
    self_service_url_reg = /\/\/dlt-dev.csuchico.edu/
    vista_url_reg = /\/\/vista-staging.csuchico.edu/
    new_self_service_url = "//dlt.csuchico.edu"
    new_vista_url = "//vista.csuchico.edu"
  end
  
  Dir.foreach("./selenium") { |file|
    unless file == "." or file == ".." or file =~ /.tmp/
      test_script = File.open("./selenium/"+file, "r+")
      new_file = String.new
      while line = test_script.gets
        if username_reg.match(line)
          puts "before: "+line
          line = line.gsub(username_reg, username)
          puts "after: "+line
        elsif vista_username_reg.match(line)
          puts "before: "+line
          line = line.gsub(vista_username_reg, vista_username)
          puts "after: "+line
        elsif password_reg.match(line)
          puts "before: "+line
          line = line.gsub(password_reg, password)
          puts "after: "+line
        elsif vista_password_reg.match(line)
          puts "before: "+line
          line = line.gsub(vista_password_reg, vista_password)
          puts "after: "+line
        elsif self_service_url_reg.match(line)
          puts "before: "+line
          line = line.gsub(self_service_url_reg, new_self_service_url)
          puts "after: "+line
        elsif vista_url_reg.match(line)
          puts "before: "+line
          line = line.gsub(vista_url_reg, new_vista_url)
          puts "after: "+line
        end # if username_reg
        new_file << line
      end # while line
      test_script.close
      new_script = File.open("./selenium/"+file, "w")
      new_script.write(new_file)
      new_script.close
    end # unless file
  }
else # environment_number not 1 or 2
  print "Error: The environment you indicated has to be 1 for staging or 2 for production."
end # if environment 1 or 2