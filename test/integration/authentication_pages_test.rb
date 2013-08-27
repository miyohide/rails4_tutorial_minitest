# coding: utf-8

require "test_helper"

describe "AuthenticationPages Integration Test" do
   subject { page }

   describe "signin page" do
      before { visit signin_path }

      it { must_have_content('Sign in') }
      it { must_have_title('Sign in') }
   end

   describe "signin" do
      before { visit signin_path }

      describe "with invalid information" do
         before { click_button "Sign in" }

         it { must_have_title('Sign in') }
         it { must_have_selector('div.alert.alert-error', text: 'Invalid') }

         describe "after visiting another page" do
            before { click_link "Home" }
            it { wont_have_selector('div.alert.alert-error') }
         end
      end

      describe "with valid information" do
         let(:user) { FactoryGirl.create(:user) }

         before do
            fill_in "Email",       with: user.email.upcase
            fill_in "Password",    with: user.password
            click_button "Sign in"
         end

         it { must_have_title(user.name) }
         it { must_have_link('Profile',    href: user_path(user)) }
         it { must_have_link('Sign out',   href: signout_path) }
         it { wont_have_link('Sign in',    href: signin_path) }

         describe "followed by signout" do
            before { click_link "Sign out" }
            it { must_have_link('Sign in') }
         end
      end
   end
end

