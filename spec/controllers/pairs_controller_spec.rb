require 'spec_helper'

class FakePair
  attr_accessor :id,:accepted, :suggested, :availability, :accept, :saved, :save_count, :reciprocal_pair, :availability_id, :available_pair_id

  def save
    @saved = self.clone
    @save_count ||= 0
    @save_count += 1
  end

  def find_reciprocal_pair
    @reciprocal_pair
  end

end
class FakeAvailability
  attr_accessor :id,:user_id
end
class FakeUserSession
  attr_accessor :user_id, :user
end
class FakeUser
  attr_accessor :id
end

describe PairsController do

  availability = nil
  pair = nil
  reciprocal_pair = nil
  user_session = nil
  user = nil
  other_user = nil

  before do

    availability = FakeAvailability.new
    other_availability = FakeAvailability.new
    pair = FakePair.new
    reciprocal_pair = FakePair.new
    user_session = FakeUserSession.new
    user = FakeUser.new
    other_user = FakeUser.new

    pair.id = rand(100)
    reciprocal_pair.id = rand(100)
    user.id = rand(100)
    availability.id = rand(100)
    other_availability.id = availability.id + 1
    other_user.id = availability.id + 1
    user_session.user = user
    user_session.user_id = user.id
    pair.availability = availability
    pair.availability_id = availability.id
    pair.available_pair_id = other_availability.id
    pair.reciprocal_pair = reciprocal_pair

  end

  describe "when suggesting pairing" do

    describe "and the user is not logged in" do
      before do
        UserSession.stub!(:find).and_return(nil)
      end

      it "should redirect to the login page" do
        post :suggest, :id => 1234
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "and the user is logged in" do

      before do
        UserSession.stub!(:find).and_return(user_session)
        Pair.stub!(:find).with(pair.id.to_s).once.and_return(pair)
      end

      describe "and the pair belongs to a different user" do
        before do
          availability.user_id = other_user.id
        end

        it "should redirect to the homepage" do
          post :suggest, :id => pair.id
          response.should redirect_to(root_url)
        end
      end

      describe "and the pair belongs to the current user" do
        before do
          availability.user_id = user.id
        end

        it "should redirect back to the show availability page" do
          post :suggest, :id => pair.id
          response.should redirect_to(availability_url(availability))
        end

        describe "and the pairing has not been suggested" do

          before do
            pair.suggested = false
            pair.accepted = false
          end

          it "should save the pair as accepted" do

            post :suggest, :id => pair.id

            pair.saved.accepted.should be true
            pair.save_count.should be(1)

          end

          it "should save the reciprocal pair as suggested" do

            post :suggest, :id => pair.id

            reciprocal_pair.saved.suggested.should be true
            reciprocal_pair.save_count.should be(1)

          end
        end

        describe "and the pairing has been suggested" do

          before do
            pair.suggested = true
            pair.accepted = true
          end

          it "should clear all other suggested pairs for this availability" do
            post :suggest, :id => pair.id
            raise "TODO: missing test"
          end

          it "should clear all other suggested pairs for the pair's availability" do
            post :suggest, :id => pair.id
            raise "TODO: missing test"
          end
        end
      end
    end
  end

  describe "when cancelling a suggested pairing" do

    describe "and the user is not logged in" do
      before do
        UserSession.stub!(:find).and_return(nil)
      end

      it "should redirect to the login page" do
        post :cancel, :id => 1234
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "and the user is logged in" do

      before do
        UserSession.stub!(:find).and_return(user_session)
        Pair.stub!(:find).with(pair.id.to_s).once.and_return(pair)
      end

      describe "and the pair belongs to a different user" do
        before do
          availability.user_id = other_user.id
        end

        it "should redirect to the homepage" do
          post :cancel, :id => pair.id
          response.should redirect_to(root_url)
        end
      end

      describe "and the pair belongs to the current user" do
        before do
          availability.user_id = user.id
        end

        it "should redirect back to the show availability page" do
          post :cancel, :id => pair.id
          response.should redirect_to(availability_url(availability))
        end

        describe "and the pairing has been suggested" do

          before do
            pair.accepted = true
            reciprocal_pair.suggested = true
          end

          it "should save the pair as not accepted" do

            post :cancel, :id => pair.id

            pair.saved.accepted.should be false
            pair.save_count.should be(1)

          end

          it "should save the reciprocal pair as not suggested" do

            post :cancel, :id => pair.id

            reciprocal_pair.saved.suggested.should be false
            reciprocal_pair.save_count.should be(1)

          end
        end
      end
    end
  end

end