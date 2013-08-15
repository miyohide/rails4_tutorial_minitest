# coding: utf-8
require "test_helper"

describe "StaticPages Integration Test" do
  describe "Home page" do
    it "should have the h1 'Sample App'" do
      visit root_path
      page.must_have_content('Sample App')
    end

    it "should have the base title" do
      visit root_path
      page.must_have_title 'Ruby on Rails Tutorial Sample App'
    end
    
    it "should not have a custom page title" do
      visit root_path
      page.wont_have_title '| Home'
    end
  end

  describe "Help page" do
    it "should have the h1 'Help'" do
      visit help_path
      page.must_have_content('Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      page.must_have_title 'Ruby on Rails Tutorial Sample App | Help'
    end
  end

  describe "About page" do
    it "should have the h1 'About Us'" do
      visit about_path
      page.must_have_content('About Us')
    end

    it "should have the title 'About Us'" do
      visit about_path
      page.must_have_title 'Ruby on Rails Tutorial Sample App | About Us'
    end
  end

  describe "Contact page" do
    it "should have the content 'Contact'" do
      visit contact_path
      page.must_have_content('Contact')
    end

    it "should have the title 'Contact'" do
      visit contact_path
      page.must_have_title("Ruby on Rails Tutorial Sample App | Contact")
    end
  end
end
