class Tag < ActiveRecord::Base
  belongs_to :availability

  def to_s
    self.tag
  end
  
end
