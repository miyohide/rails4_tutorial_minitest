# coding: utf-8

require "test_helper"

describe User do
   before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: "foobar", password_confirmation: "foobar")
   end

   # subject { @user }

   it { @user.must_respond_to(:name) }
   it { @user.must_respond_to(:email) }
   it { @user.must_respond_to(:password_digest) }
   it { @user.must_respond_to(:password) }
   it { @user.must_respond_to(:password_confirmation) }
   it { @user.must_respond_to(:authenticate) }

   it { @user.valid?.must_equal true }

   describe "when name is not present" do
      before { @user.name = "" }
      it { @user.wont_be :valid? }
   end

   describe "when email is not present" do
      before { @user.email = "" }
      it { @user.wont_be :valid? }
   end

   describe "when name is too long" do
      before { @user.name = "a" * 51 }
      it { @user.wont_be :valid? }
   end

   describe "when email format is invalid" do
      it "should be invalid" do
         addresses = %w(user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com)
         addresses.each do |invalid_address|
            @user.email = invalid_address
            @user.wont_be :valid?
         end
      end
   end

   describe "when email format is valid" do
      it "should be valid" do
         addresses = %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp
                       a+b@baz.cn)
         addresses.each do |valid_address|
            @user.email = valid_address
            @user.must_be :valid?
         end
      end
   end

   describe "when email address is already taken" do
      before do
         user_with_same_email = @user.dup
         user_with_same_email.email = @user.email.upcase
         user_with_same_email.save
      end

      it { @user.wont_be :valid? }
   end

   describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { @user.wont_be :valid? }
   end

   describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by(email: @user.email) }

      describe "with valid password" do
         it { @user.must_equal found_user.authenticate(@user.password) }
      end

      describe "with invalid password" do
         let(:user_for_invalid_password) { found_user.authenticate("invalid") }

         it { @user.wont_equal user_for_invalid_password }
         it { user_for_invalid_password.must_equal false }
      end
   end

end

