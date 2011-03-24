require "rubygems"
gem "rspec"
gem "selenium-client"
require "selenium/client"
require "selenium/rspec/spec_helper"
require "spec/test/unit"

describe "Prep_area_test" do
  attr_reader :selenium_driver
  alias :page :selenium_driver

  before(:all) do
    @verification_errors = []
    @selenium_driver = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*chrome",
      :url => "https://cas.csuchico.edu/",
      :timeout_in_second => 60
  end

  before(:each) do
    @selenium_driver.start_new_browser_session
  end
  
  append_after(:each) do
    @selenium_driver.close_current_browser_session
    @verification_errors.should == []
  end
  
  it "test_prep_area_test" do
    page.open "/cas/login?service=https://dlt-dev.csuchico.edu/vista/selfservice"
    page.type "username", "mcarlson13"
    page.type "password", "R@1n5-*S"
    page.click "submit"
    page.wait_for_page_to_load "30000"
    page.click "link=Create/Delete Prep Areas"
    page.wait_for_page_to_load "30000"
    page.type "source_id", "prep test selenium"
    page.click "//input[@name='commit' and @value='Create']"
    page.wait_for_page_to_load "30000"
    begin
        page.is_text_present("success:").should be_true
    rescue ExpectationNotMetError
        @verification_errors << $!
    end
    page.click "//input[@id='rm_prep_' and @name='rm_prep[]' and @value='mcarlson13-prep test selenium']"
    page.click "//div[@id='add_rm_prep']/form[2]/input[2]"
    page.wait_for_page_to_load "30000"
    begin
        page.is_text_present("YOU ARE ABOUT TO PERMANENTLY DELETE").should be_true
    rescue ExpectationNotMetError
        @verification_errors << $!
    end
    page.type "del_confirm_field", "delete"
    page.click "confirm_btn"
    page.wait_for_page_to_load "30000"
    begin
        page.is_text_present("success:").should be_true
    rescue ExpectationNotMetError
        @verification_errors << $!
    end
  end
end
