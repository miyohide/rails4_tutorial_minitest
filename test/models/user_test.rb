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
   it { @user.must_respond_to(:feed) }
   it { @user.must_respond_to(:relationships) }
   it { @user.must_respond_to(:followed_users) }
   it { @user.must_respond_to(:reverse_relationships) }
   it { @user.must_respond_to(:following?) }
   it { @user.must_respond_to(:follow!) }
   it { @user.must_respond_to(:unfollow!) }
   it { @user.must_respond_to(:followers) }

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

      describe "status" do
         let(:unfollowed_post) do
            FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
         end
         let(:followed_user) { FactoryGirl.create(:user) }

         before do
            @user.follow!(followed_user)
            3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
         end

         it { @user.feed.must_include(@newer_micropost) }
         it { @user.feed.must_include(@older_micropost) }
         it { @user.feed.wont_include(unfollowed_post) }
         it do
            followed_user.microposts.each do |micropost|
               @user.feed.must_include(micropost)
            end
         end
      end
   end

   describe "following" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
         @user.save
         @user.follow!(other_user)
      end

      # TODO: RailsTutorialの実装と違うが、これでよいか要確認。
      it { @user.following?(other_user).wont_be_nil }
      it { @user.followed_users.must_include(other_user) }

      describe "followed user" do
         it { other_user.followers.must_include(@user) }
      end

      describe "and unfollowing" do
         before { @user.unfollow!(other_user) }

         it { @user.following?(other_user).must_be_nil }
         it { @user.followed_users.wont_include(other_user) }
      end
   end

end

