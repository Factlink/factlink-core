module SearchResults
  class SearchResultItem
    def initialize options={}
      @obj = options[:obj]
      @view = options[:view]
    end

    def to_hash
      json = Jbuilder.new

      json.the_class internal_object_class_name
      json.the_object internal_object_to_hash_cached

      json.attributes!
    end

    def internal_object_to_hash_cached
      @internal_object_to_hash_cached ||= internal_object_to_hash
    end

    private
    def internal_object_to_hash
      klass = @obj.class

      if klass == FactData
        json = JbuilderTemplate.new(@view)
        json.partial! partial: "facts/fact", formats: [:json], handlers: [:jbuilder], locals: { fact: @obj.fact }
        json.attributes!
      elsif klass == FactlinkUser
        json = JbuilderTemplate.new(@view)
        json.partial! partial: "users/user_partial", formats: [:json], handlers: [:jbuilder], locals: { user: @obj }
        json.attributes!
      elsif klass == Topic
        json = JbuilderTemplate.new(@view)
        json.partial! partial: "topics/topic", formats: [:json], handlers: [:jbuilder], locals: { topic: @obj }

        attrs = json.attributes!
        if valid_topic? attrs
          attrs
        else
          nil
        end
      else
        raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
      end
    end

    def internal_object_class_name
      if @obj.class == "FactData"
        return Fact.to_s
      else
        return @obj.class.to_s
      end
    end

    def valid_topic? attributes
      # This uses the template rendering to check if the topic is valid
      # for display. Feel free to yell and refactor this ugliness.
      attributes['channels'].length > 0
    end
  end
end
