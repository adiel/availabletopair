class PairsController < ApplicationController

  private

  def check_ownership(pair)
    if current_user.id != pair.availability.user_id
      redirect_to root_url
      return false
    end
    true
  end


  def update_pairing_status(pair,accepted)
    pair.accepted = accepted
    pair.save
    reciprocal_pair = pair.find_reciprocal_pair
    reciprocal_pair.suggested = accepted
    reciprocal_pair.save
  end

  def cancel_pairing(pair)
    update_pairing_status(pair, false)
  end

  def accept_pairing(pair)
    update_pairing_status(pair, true)
  end
  
  public

  # POST /pairs/1/suggest
  def suggest

    return unless require_user
    pair = Pair.find(params[:id])
    return unless check_ownership(pair)

    accept_pairing(pair)

    redirect_to availability_url(pair.availability)

  end

  # POST /pairs/1/cancel
  def cancel

    return unless require_user
    pair = Pair.find(params[:id])
    return unless check_ownership(pair)

    cancel_pairing(pair)

    redirect_to availability_url(pair.availability)

  end

end
