# coding: utf-8
require "test_helper"

describe "UserPages Integration Test" do
  subject { page }

  describe "profile page" do
     let(:user) { FactoryGirl.create(:user) }
     before { visit user_path(user) }

     it { must_have_content(user.name) }
     it { must_have_title(user.name) }
 
  end

  describe "signup page" do
    before { visit signup_path }

    it { must_have_content('Sign up') }
    it { must_have_title(full_title('Sign up')) }
  end

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
       it "should not create a user" do
          lambda { click_button submit }.wont_change "User.count"
       end
    end

    describe "with valid information" do
       before do
          fill_in "Name",            with: "Example User"
          fill_in "Email",           with: "user@example.com"
          fill_in "Password",        with: "foobar"
          fill_in "Confirmation",    with: "foobar"
       end

       it "should create a user" do
          lambda { click_button submit}.must_change "User.count", 1
       end

       describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by(email: 'user@example.com') }

          it { must_have_link('Sign out') }
          it { must_have_title(user.name) }
          it { must_have_selector('div.alert-success', text: 'Welcome') }
       end
    end
  end
end

