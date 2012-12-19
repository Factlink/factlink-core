module SearchResults
  class SearchResultItem

    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @obj = options[:obj]
      @view = options[:view]
    end

    def the_class
      if @obj.class == "FactData"
        return Fact.to_s
      else
        return @obj.class.to_s
      end
    end

    def the_object
      @the_object ||= the_internal_object
    end

    def to_hash
      json = Jbuilder.new

      json.the_class the_class
      json.the_object the_object

      json.attributes!
    end

    private
    def the_internal_object
      klass = @obj.class

      if klass == FactData
        return Facts::Fact.for(fact: @obj.fact, view: @view)

      elsif klass == User
        json = JbuilderTemplate.new(@view)
        json.partial! partial: "users/user", formats: [:json], handlers: [:jbuilder], locals: { user: @obj }
        json.attributes!
      elsif klass == Topic
        json = JbuilderTemplate.new(@view)
        json.partial! partial: "topics/topic", formats: [:json], handlers: [:jbuilder], locals: { topic: @obj }

        attrs = json.attributes!
        if attrs[:title]
          attrs
        else
          nil
        end
      else
        raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
      end
    end
  end
end
