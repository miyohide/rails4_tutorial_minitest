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
      page.must_have_title(full_title(''))
    end
    
    it "should not have a custom page title" do
      visit root_path
      page.wont_have_title '| Home'
    end

    describe "for signed-in users" do
       let(:user) { FactoryGirl.create(:user) }
       before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem psum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          sign_in user
          visit root_path
       end

       it "should render the user's feed" do
          user.feed.each do |item|
             page.must_have_selector("li##{item.id}", text: item.content)
          end
       end

       describe "follower/following counts" do
          let(:other_user) { FactoryGirl.create(:user) }
          before do
             other_user.follow!(user)
             visit root_path
          end

          it { must_have_link("0 following", href: following_user_path(user)) }
          it { must_have_link("1 followers", href: followers_user_path(user)) }
       end
    end
  end

  describe "Help page" do
    it "should have the h1 'Help'" do
      visit help_path
      page.must_have_content('Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      page.must_have_title(full_title('Help'))
    end
  end

  describe "About page" do
    it "should have the h1 'About Us'" do
      visit about_path
      page.must_have_content('About Us')
    end

    it "should have the title 'About Us'" do
      visit about_path
      page.must_have_title(full_title('About Us'))
    end
  end

  describe "Contact page" do
    it "should have the content 'Contact'" do
      visit contact_path
      page.must_have_content('Contact')
    end

    it "should have the title 'Contact'" do
      visit contact_path
      page.must_have_title(full_title('Contact'))
    end
  end
end
