require "test_helper"

describe Micropost do
  before do
    @micropost = Micropost.new
  end

  it "must be valid" do
    @micropost.valid?.must_equal true
  end
end
