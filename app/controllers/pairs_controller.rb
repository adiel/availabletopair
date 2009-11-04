class PairsController < ApplicationController

  def initialize(pair_connector = PairConnector.new)
    super()
    @pair_connector = pair_connector
  end

  private

  def check_ownership(pair)
    if current_user.id != pair.availability.user_id
      redirect_to root_url
      return false
    end
    true
  end
  
  public

  # POST /pairs/1/suggest
  def suggest

    return unless require_user
    pair = Pair.find(params[:id])
    return unless check_ownership(pair)

    @pair_connector.accept_pairing(pair)

    redirect_to availability_url(pair.availability)

  end

  # POST /pairs/1/cancel
  def cancel

    return unless require_user
    pair = Pair.find(params[:id])
    return unless check_ownership(pair)

    @pair_connector.cancel_pairing(pair)

    redirect_to availability_url(pair.availability)

  end

end
