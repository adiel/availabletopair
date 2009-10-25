class PairRepository

  private

  def latest_start_time (master_availability, pair_availability)
    pair_availability.start_time > master_availability.start_time ? pair_availability.start_time : master_availability.start_time
  end

  def earliest_end_time (master_availability, pair_availability)
    pair_availability.end_time < master_availability.end_time ? pair_availability.end_time : master_availability.end_time
  end

  public

  def create(master_availability,pair_availability)
    pair = Pair.new
    update(pair,master_availability,pair_availability)
  end

  def update(pair,master_availability,pair_availability)
    pair.availability_id = master_availability.id
    pair.available_pair_id = pair_availability.id
    pair.developer = pair_availability.developer
    pair.contact = pair_availability.contact
    pair.project = master_availability.project || pair_availability.project
    pair.start_time = latest_start_time(master_availability, pair_availability)
    pair.end_time = earliest_end_time(master_availability, pair_availability)
    pair.save
    pair
  end

end
