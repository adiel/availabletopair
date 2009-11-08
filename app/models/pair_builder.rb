class PairBuilder

  private

  def latest_start_time (master_availability, pair_availability)
    pair_availability.start_time > master_availability.start_time ? pair_availability.start_time : master_availability.start_time
  end

  def earliest_end_time (master_availability, pair_availability)
    pair_availability.end_time < master_availability.end_time ? pair_availability.end_time : master_availability.end_time
  end

  def matching_tags_csv(master_availability, pair_availability)
    matching = []
    master_availability.tags.each do |master_tag|
      if pair_availability.tags.any? {|pair_tag| master_tag.tag == pair_tag.tag}
        matching.push master_tag.clone
      end
    end
    matching.sort_by{|t|t.tag}.join(',')
  end

  public

  def create(master_availability,pair_availability)
    pair = Pair.new
    update(pair,master_availability,pair_availability)
  end

  def update(pair,master_availability,pair_availability)
    pair.availability_id = master_availability.id
    pair.available_pair_id = pair_availability.id
    pair.user_id = pair_availability.user_id
    pair.project = master_availability.project || pair_availability.project
    pair.start_time = latest_start_time(master_availability, pair_availability)
    pair.end_time = earliest_end_time(master_availability, pair_availability)
    pair.tags = matching_tags_csv(master_availability, pair_availability)
    pair.save
    pair
  end

end
