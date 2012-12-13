class TimeFormatter
  class << self
    include ActionView::Helpers::DateHelper

    def as_time_ago time
      time_ago_in_words formatable_time(time)
    end

    # Internal: return a Time object that has a minimum of 1.minute.ago
    #
    # time - The timestamp or Time object to be processed
    #
    # Examples
    #
    #   TimeFormatter.formatable_time(10.seconds.ago) == Time.now - 60
    #   # => true
    #
    #   TimeFormatter.formatable_time(10.minutes.ago) == 10.minutes.ago
    #   # => true
    def formatable_time time
      [Time.at(time), Time.now-60].min
    end
  end
end
