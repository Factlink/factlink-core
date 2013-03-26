class Channel < OurOhm
  class Activities
    def initialize channel
      @channel = channel
    end

    def add_created
      return if  @channel.sorted_cached_facts.count > 0
      return if has_created_activity_already

      Activity::Subject.activity(@channel.created_by, :created_channel, @channel)
    end

    private
    def has_created_activity_already
      activities = Activity.find subject_id: @channel.id,
                                 subject_class: @channel.class.to_s,
                                 action: :created_channel
      activities.size > 0
    end
  end
end
