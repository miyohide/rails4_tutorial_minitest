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
   it { @user.must_respond_to(:remember_token) }
   it { @user.must_respond_to(:authenticate) }
   it { @user.must_respond_to(:admin) }
   it { @user.must_respond_to(:microposts) }

   it { @user.valid?.must_equal true }
   it { @user.wont_be :admin? }

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

   describe "remember token" do
      before { @user.save }
      it { @user.remember_token.wont_be :blank? }
   end

   describe "with admin attribute set to 'true'" do
      before do
         @user.save!
         @user.toggle!(:admin)
      end

      it { @user.must_be :admin? }
   end

   describe "micropost associations" do
      before do
         @user.save
         @older_micropost = FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
         @newer_micropost = FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
      end
      # before { @user.save }
      # let(:older_micropost) do
      #    FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
      # end
      # let(:newer_micropost) do
      #    FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
      # end

      it "should have the right microposts in the right order" do
         @user.microposts.to_a.must_equal [@newer_micropost, @older_micropost]
      end

      it "should destroy associated microposts" do
         microposts = @user.microposts.to_a
         @user.destroy
         microposts.wont_be :empty?
         microposts.each do |micropost|
            Micropost.where(id: micropost.id).must_be :empty?
         end
      end
   end
end

