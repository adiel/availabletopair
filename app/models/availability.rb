class Availability < ActiveRecord::Base

  def pairs
    @pairs ||= find_pairs
    @pairs
  end
  
  def find_pairs
    pair_conditions = ["developer != :developer and start_time < :end_time and end_time > :start_time",
                       {:developer => developer,
                        :start_time => start_time,
                        :end_time => end_time}]
    pairs = Availability.find(:all, :conditions => pair_conditions)
    set_intersecting_start_and_end_times!(pairs)
  end

  def set_intersecting_start_and_end_times!(pairs)
    pairs.each do |pair|
      pair.start_time = pair.start_time > start_time ? pair.start_time : start_time
      pair.end_time = pair.end_time < end_time ? pair.end_time : end_time
    end
    pairs
  end
end
