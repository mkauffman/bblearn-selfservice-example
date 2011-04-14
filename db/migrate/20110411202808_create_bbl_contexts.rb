class CreateBblContexts < ActiveRecord::Migration
  def self.up
    create_table :bbl_contexts do |t|
      t.string :user_to_emulate
      t.string :additional_seconds
      t.string :userid
      t.string :method
      t.string :password
      t.string :client_vendor_id
      t.string :client_program_id
      t.string :login_extra_info
      t.string :expected_life_seconds
      t.string :ticket
      t.string :client
      t.string :session_id
      t.timestamps
    end
  end

  def self.down
    drop_table :bbl_contexts
  end
end
