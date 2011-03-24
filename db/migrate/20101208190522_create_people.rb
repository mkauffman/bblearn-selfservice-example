class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :sourced_id
      t.string :source
      t.string :empl_id
      t.string :webct_id
      t.string :full_name
      t.string :last_name
      t.string :first_name
      t.string :name_prefix
      t.string :name_suffix
      t.string :nickname
      t.string :email
      t.string :datasource
      t.string :is_mail_forwarded
      t.string :role
      t.string :primary
      t.string :status
      t.string :password
      t.string :rec_status
      t.timestamps
    end
  end
  
  def self.down
    drop_table :people
  end
end
