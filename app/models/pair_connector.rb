class PairConnector
  private

  def other_suggestions_for_this_slot(pair,reciprocal_pair)
    my_suggestions = Pair.find(:all, :conditions => {:availability_id => pair.available_pair_id})
    pairs_suggestions = Pair.find(:all, :conditions => {:availability_id => pair.availability_id})
    all_suggestions = my_suggestions + pairs_suggestions
    other_suggestions = all_suggestions.find_all do |suggested_pair|
      suggested_pair.id != pair.id && suggested_pair.id != reciprocal_pair.id
    end
    other_suggestions
  end

  def clear_other_suggestions(pair,reciprocal_pair)
    if (pair.accepted && pair.suggested)
      other_suggestions_for_this_slot(pair,reciprocal_pair).each do |other_suggested_pair|
        other_suggested_pair.accepted = false
        other_suggested_pair.save
      end
    end
  end

  def update_pairing_status(pair,accepted)
    pair.accepted = accepted
    pair.save
    reciprocal_pair = pair.find_reciprocal_pair
    reciprocal_pair.suggested = accepted
    reciprocal_pair.save

    clear_other_suggestions(pair,reciprocal_pair)
  end

  public

  def accept_pairing(pair)
    update_pairing_status(pair,true)
  end

  def cancel_pairing(pair)
    update_pairing_status(pair,false)
  end
end