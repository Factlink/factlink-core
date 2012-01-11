require 'ohm/contrib'

require_relative 'activity/subject'
require_relative 'activity/query'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser

  generic_reference :subject
  generic_reference :object

  attribute :action
  index     :action

  def self.for(search_for)
    Activity::Query.for(search_for)
  end

  def to_hash_without_time
    h = { user: user,
          action: action.to_sym,
          subject: subject, }
    h[:object] = object if object
    h
  end

end

