#! /usr/bin/env ruby

print "\r\nWhat is your self service username? "
username = gets.chomp
print "\r\nWhat is your self service password? "
password = gets.chomp
print "\r\nWhat is your vista admin username? "
vista_username = gets.chomp
print "\r\nWhat is your vista admin password? "
vista_password = gets.chomp
print "\r\nThe script will now replace the values in the tests to wipe your "
print "\r\npersonal information from being saved."

input_check_reg = /[\.\|\(\)\[\]\{\}\+\\\^\$\*\?]/
new_username = ""
username_array = username.split(//)
for c in username_array
  match = input_check_reg.match(c)
  unless match.nil?
    new_username << "\\"+match.to_s
  else
    new_username << c
  end
end
username = new_username
print "\r\nUsername modified to: "+username

new_password = ""
password_array = password.split(//)
for c in password_array
  match = input_check_reg.match(c)
  unless match.nil?
    new_password << "\\"+match.to_s
  else
    new_password << c
  end
end
password = new_password
print "\r\nPassword modified to: "+password+"\r\n"

username_reg = Regexp.new(username)
password_reg = Regexp.new(password)
vista_username_reg = Regexp.new(vista_username)
vista_password_reg = Regexp.new(vista_password)

Dir.foreach("./selenium") { |file|
  unless file == "." or file == ".." or file =~ /.tmp/
    test_script = File.open("./selenium/"+file, "r+")
    new_file = String.new
    while line = test_script.gets
      if username_reg.match(line)
        puts "before: "+line
        line = line.gsub(username_reg, 'uname')
        puts "after: "+line
      elsif vista_username_reg.match(line)
        puts "before: "+line
        line = line.gsub(vista_username_reg, 'vista_usname')
        puts "after: "+line
      elsif password_reg.match(line)
        puts "before: "+line
        line = line.gsub(password_reg, 'pword')
        puts "after: "+line
      elsif vista_password_reg.match(line)
        puts "before: "+line
        line = line.gsub(vista_password_reg, 'vista_paword')
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