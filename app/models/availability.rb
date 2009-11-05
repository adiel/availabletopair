class Availability < ActiveRecord::Base
  validates_presence_of :user_id,:start_time, :end_time
  belongs_to :user
  has_many :pairs
  strip_attributes!

  MaxDurationHrs = 12

  private

  def display_duration
     "%02dh %02dm" % [(duration_sec / 3600).floor, ((duration_sec % 3600) / 60).to_i]
  end

  def existing_availabilities_for_user_dont_overlap? ()
    !user.availabilities.any? {|p| p != self && p.start_time < end_time && p.end_time > start_time}
  end

  def validate_end_time_is_in_the_future ()
    errors.add(:end_time, "is in the past") unless end_time > Time.now
  end

  def validate_end_time_is_after_start_time()
    errors.add(:end_time, "must be after start time") unless end_time > start_time
  end

  def validate_for_overlapping_availabilities()
    unless existing_availabilities_for_user_dont_overlap?
      errors.add("You have already declared yourself available", "for some of this time")
    end
  end
  
  def validate_max_duration
    unless duration_sec <= MaxDurationHrs * 60 * 60
      errors.add("#{MaxDurationHrs}hrs is the maximum for one availability","(you have #{display_duration})")
    end
  end

  def validate
    validate_end_time_is_in_the_future
    validate_end_time_is_after_start_time
    validate_for_overlapping_availabilities
    validate_max_duration
  end


  public

  def save(pair_synchronizer = PairSynchronizer.new)
    result = super()
    pair_synchronizer.synchronize_pairs(self)
    result
  end

  def destroy(pair_synchronizer = PairSynchronizer.new)
    result = super()
    pair_synchronizer.destroy_pairs(self)
    result
  end

  def duration_sec
    end_time - start_time
  end

  def has_accepted_pair?
    pairs.any? do |pair|
      pair.accepted && pair.suggested
    end
  end

end
