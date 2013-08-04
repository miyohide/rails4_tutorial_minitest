# coding: utf-8
require "test_helper"

describe "StaticPages Integration Test" do
  describe "Home page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.must_have_content('Sample App')
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.must_have_content('Help')
    end
  end

  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.must_have_content('About Us')
    end
  end
end
