# coding: utf-8

class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
end
