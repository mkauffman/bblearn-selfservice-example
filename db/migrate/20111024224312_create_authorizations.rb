class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table "authorizations" do |t|
      t.string   "controller"
      t.string   "action"
      t.string   "role"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :authorizations
  end
end
