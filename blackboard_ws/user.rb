require 'user_ws'


class User < ActiveModel::Base
    attr_accessor :bdate, :data_id, :edu_level, :edata, :bfax,
                  :bphone1, :bphone2, :city, :company, :country,
                  :dept, :email, :edata, :fam_name, :given_name,
                  :hfax, :hphone1, :hphone2, :jtitle, :mname, :mphone,
                  :state, :street1, :street2, :wpage, :zip, :gender,
                  :id, :ins_roles, :available, :name, :password, 
                  :student_id, :sys_roles, :title, :batch_uid


    validates_presence_of :name, :password, :student_id

    def self.columns() @column ||=[]; end

    def self.column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end


    






=begin
    def initialize(attributes)
        #Bool:      available,
        #Int:       
        #String:    street1, name, street2

        usr = UserWS.new
        usr.ws_initialize_user
        @attributes.each_pair {|k, v| send("#{k}=", v)} 

    end
=end



end
