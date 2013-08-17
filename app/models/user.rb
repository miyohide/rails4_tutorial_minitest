# coding: utf-8

class User < ActiveRecord::Base
  validates :name, presence: true
end
