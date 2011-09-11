class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,  :confirmable, :recoverable, :rememberable, :trackable, :validatable

  has_many :availabilities
  has_many :pairs
  validates_presence_of :contact 

end
