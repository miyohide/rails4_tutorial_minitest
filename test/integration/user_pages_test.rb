# coding: utf-8
require "test_helper"

describe "UserPages Integration Test" do
  subject { page }

  describe "index" do
     let(:user) { FactoryGirl.create(:user) }

     before do
        sign_in user
        visit users_path
     end

     it { must_have_title('All users') }
     it { must_have_content('All users') }

     # TODO: I don't know how to write rspec before(:all)/after(:all) by minitest.
     # describe "pagination" do
     #    it { must_have_selector('div.pagination') }

     #    it "should list each user" do
     #       User.paginate(page: 1).each do |user|
     #          page.must_have_selector('li', text:user.name)
     #       end
     #    end
     # end

     describe "delete links" do
        it { wont_have_link('delete') }

        describe "as an admin user" do
           let(:admin) { FactoryGirl.create(:admin) }
           before do
              sign_in admin
              visit users_path
           end

           it { must_have_link('delete', href: user_path(User.first)) }
           it "should be able to delete another user" do
              lambda { click_link('delete', match: :first) }.must_change "User.count", -1
           end
           it { wont_have_link('delete', href: user_path(admin)) }
        end
     end
  
  end

  describe "profile page" do

     before do
        @user = FactoryGirl.create(:user)
        @m1 = FactoryGirl.create(:micropost, user: @user, content: "Foo")
        @m2 = FactoryGirl.create(:micropost, user: @user, content: "Bar")
        visit user_path(@user)
     end

     it { must_have_content(@user.name) }
     it { must_have_title(@user.name) }

     describe "microposts" do
        it { must_have_content(@m1.content) }
        it { must_have_content(@m2.content) }
        it { must_have_content(@user.microposts.count) }
     end
 
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

  describe "edit" do
     let(:user) { FactoryGirl.create(:user) }
     before { sign_in user; visit edit_user_path(user) }

     describe "page" do
        it { must_have_content("Update your profile") }
        it { must_have_title("Edit user") }
        it { must_have_link('change', href: 'http://gravatar.com/emails') }
     end

     describe "with invalid information" do
        before { click_button "Save changes" }
        it { must_have_content('error') }
     end

     describe "with valid information" do
        let(:new_name) { "New Name" }
        let(:new_email) { "new@example.com" }

        before do
           fill_in "Name",             with: new_name
           fill_in "Email",            with: new_email
           fill_in "Password",         with: user.password
           fill_in "Confirm Password", with: user.password
           click_button "Save changes"
        end

        it { must_have_title(new_name) }
        it { must_have_selector('div.alert.alert-success') }
        it { must_have_link('Sign out', href: signout_path) }

        specify { user.reload.name.must_equal new_name }
        specify { user.reload.email.must_equal new_email }
     end
  end

  describe "following/followers" do
     let(:user) { FactoryGirl.create(:user) }
     let(:other_user) { FactoryGirl.create(:user) }
     before { user.follow!(other_user) }

     describe "followed users" do
        before do
           sign_in user
           visit following_user_path(user)
        end

        it { must_have_title(full_title('Following')) }
        it { must_have_selector('h3', text: 'Following') }
        it { must_have_link(other_user.name, href: user_path(other_user)) }
     end

     describe "followers" do
        before do
           sign_in other_user
           visit followers_user_path(other_user)
        end

        it { must_have_title(full_title('Followers')) }
        it { must_have_selector('h3', text: 'Followers') }
        it { must_have_link(user.name, href: user_path(user)) }
     end
  end
end

