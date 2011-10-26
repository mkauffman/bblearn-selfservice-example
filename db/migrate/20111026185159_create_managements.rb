class CreateManagements < ActiveRecord::Migration
  def self.up
    create_table :ca_managements do |t|
      t.string :controller
      t.string :action

      t.timestamps
    end
  end

  def self.down
    drop_table :ca_managements
  end
end
