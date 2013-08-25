# coding: utf-8

require "test_helper"

describe "AuthenticationPages Integration Test" do
   subject { page }

   describe "signin page" do
      before { visit signin_path }

      it { must_have_content('Sign in') }
      it { must_have_title('Sign in') }
   end
end
