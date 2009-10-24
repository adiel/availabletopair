require 'spec_helper'

describe Availability do

  describe "when the start and end time are within the same day"  do

    it "should calculate the duration as the difference between the end and start times in seconds" do
      start_time = Time.parse("2009-11-15 09:00")
      end_time = Time.parse("2009-11-15 17:35")

      duration_sec = Availability.new(:start_time => start_time, :end_time => end_time).duration_sec

      duration_sec.should eql(end_time - start_time)
    end
  end

  describe "when the start and end time cross two days"  do

    it "should calculate the duration as the difference between the end and start times" do
      start_time = Time.parse("2009-11-15 22:00")
      end_time = Time.parse("2009-11-15 00:15")

      duration_sec = Availability.new(:start_time => start_time, :end_time => end_time).duration_sec

      duration_sec.should eql(end_time - start_time)
    end
  end

  describe "when saving"  do

    it "should sync pairs" do
      availability = Availability.new

      pair_synchronizer = mock(:pair_synchronizer)
      pair_synchronizer.should_receive(:synchronize_pairs).with(availability)

      availability.pair_synchronizer = pair_synchronizer

      availability.save
    end

  end

  describe "when destroying"  do

    it "should sync pairs" do

      availability = Availability.new

      pair_synchronizer = mock(:pair_synchronizer)
      pair_synchronizer.should_receive(:synchronize_pairs).with(availability)

      availability.pair_synchronizer = pair_synchronizer
      
      availability.destroy
    end

  end

end
