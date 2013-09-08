# coding: utf-8

require "test_helper"

describe "MicropostPages Integration Test" do
   subject { page }

   let(:user) { FactoryGirl.create(:user) }
   before { sign_in user }

   describe "micropost creation" do
      before { visit root_path }

      describe "with invalid information" do
         it "should not create a micropost" do
            lambda { click_button "Post" }.wont_change "Micropost.count"
         end

         describe "error messages" do
            before { click_button "Post" }
            it { must_have_content('error') }
         end
      end

      describe "with valid information" do
         before { fill_in 'micropost_content', with: "Lorem ipsum" }
         it "should create a micropost" do
            lambda { click_button "Post" }.must_change "Micropost.count", 1
         end
      end
   end
end

