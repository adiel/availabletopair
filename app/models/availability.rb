class Availability < ActiveRecord::Base
  validates_presence_of :user_id,:start_time, :end_time
  belongs_to :user
  has_many :pairs
  strip_attributes!
  
  def save(pair_synchronizer = PairSynchronizer.new)
    super()
    pair_synchronizer.synchronize_pairs(self)
  end

  def destroy(pair_synchronizer = PairSynchronizer.new)
    super()
    pair_synchronizer.destroy_pairs(self)
  end

  def duration_sec
    end_time - start_time
  end

end
