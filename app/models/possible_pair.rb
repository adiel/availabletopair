require 'composite_primary_keys' 

class PossiblePair < ActiveRecord::Base
  set_primary_keys :availability1, :availability2
end
