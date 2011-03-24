class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.string  :term_id
      t.string  :new_term_id
      t.integer :start_date
      t.integer :end_date
      t.string  :description
      t.boolean :current_term
      t.string  :old_term_id
      t.timestamps
    end
  end

  def self.down
    drop_table :terms
  end
end
