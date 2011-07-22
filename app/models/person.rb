class Person < ActiveResource::Base
  attr_accessor :first_name

  def self.find
    users = Array.new
    p = Person.new
    p.first_name = 'Michael'
    users.push(p)
    p = Person.new
    p.first_name = 'John'
    users.push(p)
    p = Person.new
    p.first_name = 'Peter'
    users.push(p)
    p = Person.new
    p.first_name = 'Frank'
    users.push(p)
  end
end

