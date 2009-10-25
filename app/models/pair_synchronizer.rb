class PairSynchronizer
  
  def initialize(pair_matcher = nil, pair_repository = nil)
    @pair_matcher = pair_matcher || PairMatcher.new
    @pair_repository = pair_repository || PairRepository.new
  end

  private

  def save_or_update (existing, master_availability, pair_availability)
    if existing.nil?
      @pair_repository.create(master_availability, pair_availability)
    else
      @pair_repository.update(existing, master_availability, pair_availability)
    end
  end

  def save_or_update_master(existing_pairs, availability, new_matching_availability)
    existing_master = existing_pairs.find do |pair|
      pair.available_pair_id == new_matching_availability.id
    end
    save_or_update(existing_master, availability, new_matching_availability)
  end

  def save_or_update_pair (existing_pairs, availability, new_matching_availability)
    existing_pair = existing_pairs.find do |pair|
      pair.availability_id == new_matching_availability.id
    end
    save_or_update(existing_pair, new_matching_availability, availability)
  end

  def find_existing_pairs(availability)
    conditions_clause = "availability_id = :availability_id or available_pair_id = :available_pair_id"
    conditions_params = {:availability_id => availability.id, :available_pair_id => availability.id}

    existing_pairs = Pair.find(:all, :conditions => [conditions_clause, conditions_params])
    return existing_pairs
  end

  def save_or_update_existing_pairs(availability, existing_pairs, new_matching_availabilities)
    new_matching_availabilities.each do |new_matching_availability|
      save_or_update_master(existing_pairs, availability, new_matching_availability)
      save_or_update_pair(existing_pairs, availability, new_matching_availability)
    end
  end

  def destroy_obsolete_pairs(existing_pairs, new_matching_availabilities)
    existing_pairs.each do |existing|
      match = new_matching_availabilities.find {|a| a.id == existing.availability_id || a.id == existing.available_pair_id}
      existing.destroy if match.nil?
    end
  end

  public

  def synchronize_pairs(availability)
    existing_pairs = find_existing_pairs(availability)
    new_matching_availabilities = @pair_matcher.find_pairs(availability)

    save_or_update_existing_pairs(availability, existing_pairs, new_matching_availabilities)
    destroy_obsolete_pairs(existing_pairs, new_matching_availabilities)
  end

end

