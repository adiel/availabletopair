require 'spec_helper'

describe PairRepository do
  master_availability = Availability.new(:start_time => Time.now, :end_time => Time.now)
  pair_availability = Availability.new(:start_time => Time.now, :end_time => Time.now)

  describe "when creating a pair" do

    it "should set availability_id as master id and available_to_pair id as pair id" do
      master_availability.id = 543
      pair_availability.id = 654

      pair = PairRepository.new.create(master_availability,pair_availability)

      pair.availability_id.should eql(master_availability.id)
      pair.available_pair_id.should eql(pair_availability.id)
    end

    it "should set developer as pair developer" do
      master_availability.developer = "masterdev"
      pair_availability.developer = "pairdev"

      pair = PairRepository.new.create(master_availability,pair_availability)

      pair.developer.should eql pair_availability.developer
    end

    it "should set contact as pair contact" do
      master_availability.contact = "master@xp.com"
      pair_availability.contact = "pair@xp.com"

      pair = PairRepository.new.create(master_availability,pair_availability)

      pair.contact.should eql pair_availability.contact
    end

    describe "and the start time of the pair is later than that of the master" do

      before do
        master_availability.start_time = Time.parse("2012-06-01 15:25")
        pair_availability.start_time = Time.parse("2012-06-01 15:26")
      end

      it "should use the pair's start time" do
        pair = PairRepository.new.create(master_availability,pair_availability)
        pair.start_time.should be (pair_availability.start_time)
      end

    end

    describe "and the start time of the pair is earlier than that of the master" do

      before do
        master_availability.start_time = Time.parse("2012-06-01 15:26")
        pair_availability.start_time = Time.parse("2012-06-01 15:25")
      end

      it "should use the master's start time" do
        pair = PairRepository.new.create(master_availability,pair_availability)
        pair.start_time.should be (master_availability.start_time)
      end

    end

    describe "and the end time of the pair is later than that of the master" do

      before do
        master_availability.end_time = Time.parse("2012-06-01 15:25")
        pair_availability.end_time = Time.parse("2012-06-01 15:26")
      end

      it "should use the masters's end time" do
        pair = PairRepository.new.create(master_availability,pair_availability)
        pair.end_time.should be (master_availability.end_time)
      end

    end

    describe "and the end time of the pair is earlier than that of the master" do

      before do
        master_availability.end_time = Time.parse("2012-06-01 15:26")
        pair_availability.end_time = Time.parse("2012-06-01 15:25")
      end

      it "should use the pair's end time" do
        pair = PairRepository.new.create(master_availability,pair_availability)
        pair.end_time.should be (pair_availability.end_time)
      end

    end

    describe "and a project is not specified on either" do

      before do
        master_availability.project = nil
        pair_availability.project = nil
      end

      it "should set the project nil" do
        pair = PairRepository.new.create(master_availability,pair_availability)
        pair.project.should eql nil
      end

    end

    describe "and a project is specified on the master only" do

      before do
        master_availability.project = "someProj"
        pair_availability.project = nil
      end

      it "should use the master's project" do
        pair = PairRepository.new.create(master_availability,pair_availability)
        pair.project.should eql(master_availability.project)
      end

    end

    describe "and a project is specified on the pair" do

      before do
        master_availability.project = nil
        pair_availability.project = "someProj"
      end

      it "should use the pair's project" do
        pair = PairRepository.new.create(master_availability,pair_availability)
        pair.project.should eql(pair_availability.project)
      end
    end

  end

end

