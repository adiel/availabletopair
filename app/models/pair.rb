class Pair < ActiveRecord::Base
  belongs_to :availability
  belongs_to :user

  def duration_sec
    end_time - start_time
  end

  def find_reciprocal_pair
    Pair.find(:all, :conditions => ["availability_id = :availability_id and available_pair_id = :available_pair_id",
                                    {:available_pair_id => self.availability_id, :availability_id => self.available_pair_id}])[0]
  end
  
end
