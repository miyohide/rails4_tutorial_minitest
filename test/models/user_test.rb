# coding: utf-8

require "test_helper"

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  # subject { @user }

  it { @user.must_respond_to(:name) }
  it { @user.must_respond_to(:email) }
  it { @user.valid?.must_equal true }

  describe "when name is not present" do
    before { @user.name = "" }
    it { @user.valid?.must_equal false }
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { @user.valid?.must_equal false }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { @user.valid?.must_equal false }
  end
end
