class Pair < ActiveRecord::Base
  belongs_to :availability
  belongs_to :user

  def duration_sec
    end_time - start_time
  end
end
