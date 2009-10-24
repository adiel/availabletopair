class Pair < ActiveRecord::Base
  belongs_to :availability

  def duration_sec
    end_time - start_time
  end
end
