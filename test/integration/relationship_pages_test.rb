# coding: utf-8

require "test_helper"

describe "RelationshipPages Integration Test" do
   let(:user) { FactoryGirl.create(:user) }
   let(:other_user) { FactoryGirl.create(:user) }

   before { sign_in user, no_capybara: true }

   describe "creating a relationship with Ajax" do
      it "should increment the Relationship count" do
         lambda {
            xhr :post, relationships_path, relationship: { followed_id: other_user.id }
         }.must_change "Relationship.count", 1
      end

      it "should respond with success" do
         xhr :post, relationships_path, relationship: { followed_id: other_user.id }
         response.status.must_equal 200
      end
   end
   
   describe "destroying a relationship with Ajax" do
      before { user.follow!(other_user) }
      let(:relationship) { user.relationships.find_by(followed_id: other_user) }

      it "should decrement the Relationship count" do
         lambda do
            xhr :delete, relationship_path(relationship), id: relationship.id
         end.must_change "Relationship.count", -1
      end

      it "should respond with success" do
         xhr :delete, relationship_path(relationship), id: relationship.id
         response.status.must_equal 200
      end
   end
end

