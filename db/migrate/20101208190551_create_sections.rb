class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :source
      t.string :lc_id
      t.string :section_id
      t.string :short_name
      t.string :long_name
      t.string :full_name
      t.string :timeframe_begin
      t.string :timeframe_restrict_begin
      t.string :timeframe_end
      t.string :timeframe_restrict_end
      t.string :accept_enrollment
      t.string :datasource
      t.string :parent_source
      t.string :parent_id
      t.string :template_parent_id
      t.string :template_parent_source
      t.string :template_zip_or_epk_path
      t.string :template_none
      t.string :delivery_unit_type
      t.string :term_name
      t.string :term_id
      t.string :admin_period
      t.string :term_datasource
      t.string :primary_instructor_name
      t.string :primary_instructor_id
      t.string :admin_xlist_sect_type
      t.string :level
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
