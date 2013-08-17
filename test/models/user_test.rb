# coding: utf-8

require "test_helper"

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  # subject { @user }

  it { @user.must_respond_to(:name) }
  it { @user.must_respond_to(:email) }

end
