class Availability < ActiveRecord::Base

  def initialize(availability = nil)
    super
  end

  def pairs
    @pairs ||= find_pairs
    @pairs
  end
  
  def find_pairs
    conditions  = "developer != :developer and start_time < :end_time and end_time > :start_time"
    condition_values = {:developer => developer,
                        :start_time => start_time,
                        :end_time => end_time}
    if project.to_s != ""
      conditions += " and (project = :project or project = '')"
      condition_values[:project] = project
    end
    
    pair_conditions = [conditions, condition_values]
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

  def duration_sec
    end_time - start_time
  end

end
