
class StartAndEndDatesValidator < ActiveModel::Validator
  # implement the method where the validation logic must reside
  def validate(availability)
    @availability = availability
    
    validate_end_time_is_in_the_future
    validate_end_time_is_after_start_time
    validate_for_overlapping_availabilities
    validate_max_duration
  end
  
  MaxDurationHrs = 12
  
  def errors
    @availability.errors
  end
  
  def start_time
    @availability.start_time
  end
  
  def end_time
    @availability.end_time
  end
  
  def user
    @availability.user
  end
  
  def duration_sec
    @availability.duration_sec
  end
  
  def display_duration
     "%02dh %02dm" % [(duration_sec / 3600).floor, ((duration_sec % 3600) / 60).to_i]
  end

  def existing_availabilities_for_user_overlap?
    user.availabilities.any? {|p| p != @availability && p.start_time < end_time && p.end_time > start_time}
  end

  def validate_end_time_is_in_the_future
    errors.add(:end_time, "is in the past") unless end_time > Time.now
  end

  def validate_end_time_is_after_start_time
    errors.add(:end_time, "must be after start time") unless end_time > start_time
  end

  def validate_for_overlapping_availabilities()
    if existing_availabilities_for_user_overlap?
      errors.add("You have already declared yourself available", "for some of this time")
    end
  end
  
  def validate_max_duration
    unless duration_sec <= MaxDurationHrs * 60 * 60
      errors.add("#{MaxDurationHrs}hrs is the maximum for one availability","(you have #{display_duration})")
    end
  end

end


class Availability < ActiveRecord::Base

  validates_with StartAndEndDatesValidator
  validates_presence_of :user_id,:start_time, :end_time
  belongs_to :user
  has_many :pairs
  has_many :availabilities_tags_links, :dependent => :destroy
  has_many :tags, :through => :availabilities_tags_links
  #strip_attributes!


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

  def sort_pairs_by_matching_tag_count_and_updated_at_desc
    self.pairs.sort! do |p1,p2|
	tag_count_1 = p1.tags.split(',').length
	tag_count_2 = p2.tags.split(',').length
    if tag_count_1 != tag_count_2
      tag_count_1 <=> tag_count_2
    else
      p1.updated_at <=> p2.updated_at
    end
    end.reverse!
  end
  
  def self.render_args
	  {:include => {:tags => {:only => :tag},
                      :user => {
                        :only => :username
                      },
                      :pairs => {
                        :include => {
                          :user => {
                            :only => :username
                          }
                        }
                      }
                    }
          }
  end

  def self.filter_by_start_and_end_date!(availabilities,params)
    from_date = params[:from_date].nil? ? nil : Date.parse(params[:from_date]);
    to_date = params[:to_date].nil? ? nil : Date.parse(params[:to_date]);
    to_date += 1 unless to_date.nil?

    unless from_date.nil? && to_date.nil?

      availabilities = availabilities.find_all do |a|
        (from_date.nil? || (a.start_time >= from_date && a.start_time < to_date)) ||
                (to_date.nil? || (a.end_time >= from_date && a.end_time < to_date))
      end

    end
    availabilities
  end
  

end

