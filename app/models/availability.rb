class Availability < ActiveRecord::Base
  validates_presence_of :developer, :contact, :start_time, :end_time
  has_many :pairs
  strip_attributes!

  def pair_synchronizer
    @pair_synchronizer ||= PairSynchronizer.new
  end

  def pair_synchronizer=(pair_synchronizer)
    @pair_synchronizer = pair_synchronizer
  end

  def save
    super()
    pair_synchronizer.synchronize_pairs(self)
  end

  def destroy
    super()
    pair_synchronizer.synchronize_pairs(self)
  end
  
  def duration_sec
    end_time - start_time
  end

end
