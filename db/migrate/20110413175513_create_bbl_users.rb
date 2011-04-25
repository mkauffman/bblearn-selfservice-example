class CreateBblUsers < ActiveRecord::Migration
  def self.up
    create_table :bbl_users do |t|
      t.string :birth_date
      t.string :datasource_id
      t.string :education_level
      t.string :expansion_data
      t.string :business_fax
      t.string :business_phone_1
      t.string :business_phone_2
      t.string :city
      t.string :company
      t.string :country
      t.string :department
      t.string :email
      t.string :family_name
      t.string :given_name
      t.string :home_fax
      t.string :home_phone_1
      t.string :home_phone_2
      t.string :job_title
      t.string :middle_name
      t.string :mobile_phone
      t.string :state
      t.string :street_1
      t.string :street_2
      t.string :web_page
      t.string :zip_code
      t.string :gender
      t.string :id
      t.string :ins_roles
      t.string :is_available
      t.string :name
      t.string :password
      t.string :student_id
      t.string :system_roles
      t.string :title
      t.string :user_batch_id
      t.timestamps
    end
  end

  def self.down
    drop_table :bbl_users
  end
end
