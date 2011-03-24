require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "test should not save role without portal_id and role" do
    role = Role.new
    assert !role.save, "saved role without portal_id and role"
  end
  
  test "portal_id must be unique" do
    role = Role.new(:portal_id => "mcarlson13", :role => "admin")
    assert !role.save, "saved role that already exists"
  end
end
