require 'spec_helper'

describe PairMatcher do

  it "should find pair as matching availabilities for different developers where times overlap" do
    availability = Availability.new(:start_time => Time.now,:end_time => Time.now)
    availability.developer = "currentDev"
    expected_pairs = [Availability.new(:start_time => Time.now,:end_time => Time.now)]
    Availability.stub!(:find).with(:all,
                                   :conditions => ["developer != :developer and start_time < :end_time and end_time > :start_time",
                                                  {:developer => availability.developer,
                                                   :start_time => availability.start_time,
                                                   :end_time => availability.end_time}]).and_return(expected_pairs)

    actual_pairs = PairMatcher.new.find_pairs(availability)

    actual_pairs.should be(expected_pairs)
  end

  describe "when a project has been specified" do

    it "should find pair as matching availabilities for different developers on the same project or anything where times overlap" do
      availability = Availability.new(:start_time => Time.now,:end_time => Time.now)
      availability.developer = "currentDev"
      availability.project = "some proj"
      expected_pairs = [Availability.new(:start_time => Time.now,:end_time => Time.now)]
      Availability.stub!(:find).with(:all,
                                     :conditions => ["developer != :developer and start_time < :end_time and end_time > :start_time and (project = :project or project = '')",
                                                    {:developer => availability.developer,
                                                     :start_time => availability.start_time,
                                                     :end_time => availability.end_time,
                                                     :project => availability.project}]).and_return(expected_pairs)

      actual_pairs = PairMatcher.new.find_pairs(availability)

      actual_pairs.should be(expected_pairs)
    end
  end
 
end

