require "test_helper"

describe "StaticPages Integration Test" do
  describe "Home page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.must_have_content('Sample App')
    end
  end
end
