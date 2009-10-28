class PairMatcher
    
  def find_pairs(availability)
    conditions  = "user_id != :user_id and start_time < :end_time and end_time > :start_time"
    condition_values = {:user_id => availability.user_id,
                        :start_time => availability.start_time,
                        :end_time => availability.end_time}

    if !availability.project.blank?
      conditions += " and (project = :project or project is null)"
      condition_values[:project] = availability.project
    end

    pair_conditions = [conditions, condition_values]
    Availability.find(:all, :conditions => pair_conditions)
  end

end
 