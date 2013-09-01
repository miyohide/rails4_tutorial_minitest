require "test_helper"

describe Micropost do
   let(:user) { FactoryGirl.create(:user) }

   before do
      @micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
   end

   # subject { @micropost }

   it { @micropost.must_respond_to(:content) }
   it { @micropost.must_respond_to(:user_id) }

end
