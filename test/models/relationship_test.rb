# coding: utf-8

require "test_helper"

describe Relationship do
   let(:follower) { FactoryGirl.create(:user) }
   let(:followed) { FactoryGirl.create(:user) }
   let(:relationship) { follower.relationships.build(followed_id: followed.id) }

   # subject { relationship }

   # TODO subjectがうまく動かない
   it { relationship.must_be :valid? }

   describe "follower methods" do
      it { relationship.must_respond_to(:follower) }
      it { relationship.must_respond_to(:followed) }
      it { relationship.follower.must_equal follower }
      it { relationship.followed.must_equal followed }
   end
end
