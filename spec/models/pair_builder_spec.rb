require 'spec_helper'

describe PairBuilder do
  master_availability = Availability.new(:start_time => Time.now, :end_time => Time.now)
  pair_availability = Availability.new(:start_time => Time.now, :end_time => Time.now)

  describe "when creating a pair" do

    it "should set availability_id as master id and available_to_pair id as pair id" do
      master_availability.id = 543
      pair_availability.id = 654

      pair = PairBuilder.new.create(master_availability,pair_availability)

      pair.availability_id.should eql(master_availability.id)
      pair.available_pair_id.should eql(pair_availability.id)
    end

    it "should set developer as pair developer" do
      master_availability.user_id = 54321
      pair_availability.user_id = 98765

      pair = PairBuilder.new.create(master_availability,pair_availability)

      pair.user_id.should eql pair_availability.user_id
    end

    describe "and the start time of the pair is later than that of the master" do

      before do
        master_availability.start_time = Time.parse("2012-06-01 15:25")
        pair_availability.start_time = Time.parse("2012-06-01 15:26")
      end

      it "should use the pair's start time" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.start_time.should be(pair_availability.start_time)
      end

    end

    describe "and the start time of the pair is earlier than that of the master" do

      before do
        master_availability.start_time = Time.parse("2012-06-01 15:26")
        pair_availability.start_time = Time.parse("2012-06-01 15:25")
      end

      it "should use the master's start time" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.start_time.should be(master_availability.start_time)
      end

    end

    describe "and the end time of the pair is later than that of the master" do

      before do
        master_availability.end_time = Time.parse("2012-06-01 15:25")
        pair_availability.end_time = Time.parse("2012-06-01 15:26")
      end

      it "should use the masters's end time" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.end_time.should be(master_availability.end_time)
      end

    end

    describe "and the end time of the pair is earlier than that of the master" do

      before do
        master_availability.end_time = Time.parse("2012-06-01 15:26")
        pair_availability.end_time = Time.parse("2012-06-01 15:25")
      end

      it "should use the pair's end time" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.end_time.should be(pair_availability.end_time)
      end

    end

    describe "and a project is not specified on either" do

      before do
        master_availability.project = nil
        pair_availability.project = nil
      end

      it "should set the project nil" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.project.should eql nil
      end

    end

    describe "and a project is specified on the master only" do

      before do
        master_availability.project = "someProj"
        pair_availability.project = nil
      end

      it "should use the master's project" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.project.should eql(master_availability.project)
      end

    end

    describe "and a project is specified on the pair" do

      before do
        master_availability.project = nil
        pair_availability.project = "someProj"
      end

      it "should use the pair's project" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.project.should eql(pair_availability.project)
      end
    end
    
    describe "and there are no matching tags" do

      before do
        master_availability.tags = []
        pair_availability.tags = []
      end

      it "should have empty tags" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.tags.should eql("")
      end
    end
    
    describe "and only some tags match" do

      before do
        master_availability.tags = [Tag.new(:tag => "grub"),Tag.new(:tag => "cuthbert"),Tag.new(:tag => "dibble")]
        pair_availability.tags = [Tag.new(:tag => "dibble"),Tag.new(:tag => "cuthbert"),Tag.new(:tag => "dibble")]
      end

      it "should have the matching tags as csv in alphabetical order" do
        pair = PairBuilder.new.create(master_availability,pair_availability)
        pair.tags.should eql("cuthbert, dibble")
      end
    end

  end

end

