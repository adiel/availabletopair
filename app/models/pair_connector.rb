class PairConnector
  private

  def update_pairing_status(pair,accepted)
    pair.accepted = accepted
    pair.save
    reciprocal_pair = pair.find_reciprocal_pair
    reciprocal_pair.suggested = accepted
    reciprocal_pair.save
  end

  public

  def accept_pairing(pair)
    update_pairing_status(pair,true)
  end

  def cancel_pairing(pair)
    update_pairing_status(pair,false)
  end
end