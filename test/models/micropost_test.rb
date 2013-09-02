require "test_helper"

describe Micropost do
   let(:user) { FactoryGirl.create(:user) }

   before do
      @micropost = user.microposts.build(content: "Lorem ipsum")
   end

   # subject { @micropost }

   it { @micropost.must_respond_to(:content) }
   it { @micropost.must_respond_to(:user_id) }
   it { @micropost.must_respond_to(:user) }
   it { @micropost.user.must_equal user }

   it { @micropost.must_be :valid? }

   describe "when user_id is not present" do
      before { @micropost.user_id = nil }
      it { @micropost.wont_be :valid? }
   end

end
