class User < ActiveRecord::Base
  has_many :availabilities
  has_many :pairs
  validates_presence_of :contact 

  acts_as_authentic do |c|
    c.openid_required_fields = [:nickname, :email]
  end

end
