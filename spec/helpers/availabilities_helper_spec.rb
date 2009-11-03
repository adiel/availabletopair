require 'spec_helper'
=begin

class FakePair
  attr_accessor :accepted
  def accepted
    @accepted
  end
end


class AvailabilitiesHelperTester
  include AvailabilitiesHelper
end

describe AvailabilitiesHelper do

  describe "when building suggest/accept pair links" do

    pair = FakePair.new

    describe "and the pairing has not been suggested" do

      before do
        pair.accepted = false 
      end

      it "should build a link to the availability with action suggest and method post" do

        link = AvailabilitiesHelperTester.new.link_to_suggest_accept(pair)

        link.should_be "asdf"

      end

    end

  end

end

=end
