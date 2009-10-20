require 'spec_helper'

describe Availability do

  it "should find pairs as matching availabilities for different developers where times overlap" do
    availability = Availability.new(:start_time => Time.now,:end_time => Time.now)
    availability.developer = "currentDev"
    expected_pairs = [Availability.new(:start_time => Time.now,:end_time => Time.now)]
    Availability.stub!(:find).with(:all,
                                   :conditions => ["developer != :developer and start_time < :end_time and end_time > :start_time",
                                                  {:developer => availability.developer,
                                                   :start_time => availability.start_time,
                                                   :end_time => availability.end_time}]).and_return(expected_pairs)

    actual_pairs = availability.pairs

    actual_pairs.should be(expected_pairs)
  end

  describe "when a project has been specified" do

    it "should find pairs as matching availabilities for different developers on the same project or anything where times overlap" do
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

      actual_pairs = availability.pairs

      actual_pairs.should be(expected_pairs)
    end
  end

  it "should set the start time of each pair to the later of the two start times" do
    availability = Availability.new(:start_time => Time.parse("2012-06-01 15:25"),:end_time => Time.now)

    pair_1 = Availability.new(:start_time => Time.parse("2012-06-01 15:26"),:end_time => Time.now)
    pair_2 = Availability.new(:start_time => Time.parse("2012-06-01 15:24"),:end_time => Time.now)
    expected_pairs = [pair_1,pair_2]

    Availability.stub!(:find).and_return(expected_pairs)

    actual_pairs = availability.pairs

    actual_pairs[0].start_time.should be (pair_1.start_time)
    actual_pairs[1].start_time.should be (availability.start_time)
  end

  it "should set the end time of each pair to the earlier of the two end times" do
    availability = Availability.new(:end_time => Time.parse("2012-06-01 15:25"),:start_time => Time.now)

    pair_1 = Availability.new(:end_time => Time.parse("2012-06-01 15:24"),:start_time => Time.now)
    pair_2 = Availability.new(:end_time => Time.parse("2012-06-01 15:26"),:start_time => Time.now)

    expected_pairs = [pair_1,pair_2]

    Availability.stub!(:find).and_return(expected_pairs)

    actual_pairs = availability.pairs

    actual_pairs[0].end_time.should be (pair_1.end_time)
    actual_pairs[1].end_time.should be (availability.end_time)
  end

end
