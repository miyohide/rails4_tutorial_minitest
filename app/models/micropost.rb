# coding: utf-8

class Micropost < ActiveRecord::Base
   validates :user_id, presence: true
end
