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
         it { must_have_link('Settings',   href: edit_user_path(user)) }
         it { must_have_link('Sign out',   href: signout_path) }
         it { wont_have_link('Sign in',    href: signin_path) }

         describe "followed by signout" do
            before { click_link "Sign out" }
            it { must_have_link('Sign in') }
         end
      end
   end

   describe "authorization" do
      describe "for non-signed-in users" do
         let(:user) { FactoryGirl.create(:user) }

         describe "in the Users controller" do
            describe "visiting the edit page" do
               before { visit edit_user_path(user) }
               it { must_have_title('Sign in') }
            end

            describe "submitting to the update action" do
               before { patch user_path(user) }
               specify { response.must_redirected_to(signin_path) }
            end

            describe "visiting the user index" do
               before { visit users_path }
               it { must_have_title('Sign in') }
            end
         end

         describe "when attempting to visit a protected page" do
            before do
               visit edit_user_path(user)
               fill_in "Email",     with: user.email
               fill_in "Password",  with: user.password
               click_button "Sign in"
            end

            describe "after signing in" do
               it "should render the desired protected page" do
                  page.must_have_title('Edit user')
               end
            end
         end
      end

      describe "as wrong user" do
         let(:user) { FactoryGirl.create(:user) }
         let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
         before { sign_in user, no_capybara: true }

         describe "visiting Users#edit page" do
            before { visit edit_user_path(wrong_user) }
            it { wont_have_title(full_title('Edit user')) }
         end

         describe "submitting a PATCH request to the Users#update action" do
            before { patch user_path(wrong_user) }
            specify { response.must_redirected_to(root_url) }
         end
      end
   end
end
