require 'ohm/contrib'

require File.join(File.dirname(__FILE__), "activity", "subject")
require File.join(File.dirname(__FILE__), "activity", "query")


class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser

  generic_reference :subject
  generic_reference :object

  attribute :action

  def self.for(search_for)
    Activity::Query.for(search_for)
  end
end

