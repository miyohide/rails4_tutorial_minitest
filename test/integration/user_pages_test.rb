# coding: utf-8
require "test_helper"

describe "UserPages Integration Test" do
  subject { page }
  describe "signup page" do
    before { visit signup_path }

    it { must_have_content('Sign up') }
    it { must_have_title(full_title('Sign up')) }
  end
end

