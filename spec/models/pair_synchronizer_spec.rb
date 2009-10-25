require 'spec_helper'

describe PairSynchronizer do

  describe "when syncing pairing" do

    describe "when there is a single new availability" do

      availability = Availability.new
      matching_availabilities = []
      existing_pairs = []

      before do

        availability.id = 321
        matching_availabilities = create_test_availabilities([5])
        existing_pairs = []

        Pair.stub!(:find).with(:all, :conditions => ["availability_id = :availability_id or available_pair_id = :available_pair_id", {:availability_id => availability.id, :available_pair_id => availability.id}]).and_return([])

      end

      it "should create two pairing for the new match, one in each direction" do

        pair_matcher = mock(:pair_matcher)
        pair_repository = mock(:pair_matcher)
        pair_matcher.stub!(:find_pairs).with(availability).and_return(matching_availabilities)

        pair_repository.should_receive(:create).with(availability,matching_availabilities[0])
        pair_repository.should_receive(:create).with(matching_availabilities[0],availability)

        PairSynchronizer.new(pair_matcher,pair_repository).synchronize_pairs(availability)
      end
    end

    describe "when there some existing and some new availabilities" do

      availability = Availability.new
      matching_availabilities = []
      existing_pairs = []

      before do

        availability.id = 321
        matching_availabilities = create_test_availabilities([5,6,7,8])

        existing_pairs = [stub(:availability_id => availability.id, :available_pair_id => matching_availabilities[0].id),
                          stub(:availability_id => matching_availabilities[0].id, :available_pair_id => availability.id),
                          stub(:availability_id => availability.id, :available_pair_id => matching_availabilities[2].id),
                          stub(:availability_id => matching_availabilities[2].id, :available_pair_id => availability.id)]

        Pair.stub!(:find).with(:all, :conditions => ["availability_id = :availability_id or available_pair_id = :available_pair_id", {:availability_id => availability.id, :available_pair_id => availability.id}]).and_return(existing_pairs)

      end

      it "should create any matching pair that doesn't exist" do

        pair_matcher = mock(:pair_matcher)
        pair_repository = mock(:pair_matcher)
        pair_matcher.stub!(:find_pairs).with(availability).and_return(matching_availabilities)

        pair_repository.should_receive(:create).with(availability,matching_availabilities[1])
        pair_repository.should_receive(:create).with(matching_availabilities[1],availability)
        pair_repository.should_receive(:create).with(availability,matching_availabilities[3])
        pair_repository.should_receive(:create).with(matching_availabilities[3],availability)

        pair_repository.stub!(:update)

        PairSynchronizer.new(pair_matcher,pair_repository).synchronize_pairs(availability)

      end

      it "should update the existing availabilities" do

        pair_matcher = mock(:pair_matcher)
        pair_repository = mock(:pair_matcher)
        pair_matcher.stub!(:find_pairs).with(availability).and_return(matching_availabilities)

        pair_repository.should_receive(:update).with(existing_pairs[0],availability,matching_availabilities[0])
        pair_repository.should_receive(:update).with(existing_pairs[1],matching_availabilities[0],availability)
        pair_repository.should_receive(:update).with(existing_pairs[2],availability,matching_availabilities[2])
        pair_repository.should_receive(:update).with(existing_pairs[3],matching_availabilities[2],availability)

        pair_repository.stub!(:create)

        PairSynchronizer.new(pair_matcher,pair_repository).synchronize_pairs(availability)

      end

    end

    describe "when there are missing availabilities" do

      availability = Availability.new
      matching_availabilities = []
      existing_pairs = []

      before do

        availability.id = 321
        matching_availabilities = create_test_availabilities([5])

        existing_pairs = [mock(:id => 99, :availability_id => availability.id, :available_pair_id => 5),
                          mock(:id => 98, :availability_id => 5, :available_pair_id => availability.id),
                          mock(:id => 97,:availability_id => availability.id, :available_pair_id => 102),
                          mock(:id => 96,:availability_id => 102, :available_pair_id => availability.id),
                          mock(:id => 95,:availability_id => availability.id, :available_pair_id => 103),
                          mock(:id => 94,:availability_id => 103, :available_pair_id => availability.id)]

        Pair.stub!(:find).with(:all, :conditions => ["availability_id = :availability_id or available_pair_id = :available_pair_id", {:availability_id => availability.id, :available_pair_id => availability.id}]).and_return(existing_pairs)

      end

      it "should destroy the missing pairing" do

        pair_matcher = mock(:pair_matcher)
        pair_repository = mock(:pair_matcher)
        pair_matcher.stub!(:find_pairs).with(availability).and_return(matching_availabilities)

        existing_pairs[2].should_receive(:destroy)
        existing_pairs[3].should_receive(:destroy)
        existing_pairs[4].should_receive(:destroy)
        existing_pairs[5].should_receive(:destroy)

        pair_repository.stub!(:create)
        pair_repository.stub!(:update)

        PairSynchronizer.new(pair_matcher,pair_repository).synchronize_pairs(availability)

      end
    end
  end

end

def create_test_availabilities(ids)
  availabilities = []
  ids.each do |id|
    availability = Availability.new
    availability.id = id
    availabilities.push availability
  end
  availabilities  
end
