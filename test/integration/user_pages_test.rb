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
end

