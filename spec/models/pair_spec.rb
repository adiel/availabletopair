require 'spec_helper'

describe Pair do

  it "should find the reciprocal pair by reversing availability_id and available_pair_id" do

    pair = Pair.new
    pair.availability_id = 112358
    pair.available_pair_id = 135711

    expected_reciprocal_pair = Pair.new

    Pair.stub!(:find).with(:all, :conditions => ["availability_id = :availability_id and available_pair_id = :available_pair_id",
                                                 {:available_pair_id => pair.availability_id, :availability_id => pair.available_pair_id}]).and_return([expected_reciprocal_pair])

    pair.find_reciprocal_pair.should be expected_reciprocal_pair

  end

end