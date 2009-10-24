class PairMatcher
    
  def find_pairs(availability)
    conditions  = "developer != :developer and start_time < :end_time and end_time > :start_time"
    condition_values = {:developer => availability.developer,
                        :start_time => availability.start_time,
                        :end_time => availability.end_time}
    if availability.project.to_s != ""
      conditions += " and (project = :project or project = '')"
      condition_values[:project] = availability.project
    end

    pair_conditions = [conditions, condition_values]
    pairs = Availability.find(:all, :conditions => pair_conditions)
  end

end
 