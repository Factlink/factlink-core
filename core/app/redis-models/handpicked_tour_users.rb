require 'redis-aid'

class HandpickedTourUsers
  attr_reader :handpicked_tour_users_interface

  def initialize nest_key=Nest.new(:user)[:handpicked_tour_users]
    @handpicked_tour_users_interface = nest_key
  end

  def members
    ids.map {|id| User.find(id)}
       .compact
  end

  def add id
    handpicked_tour_users_interface.sadd id.to_s
  end

  def remove id
    handpicked_tour_users_interface.srem id.to_s
  end

  private
  def ids
    handpicked_tour_users_interface.smembers
  end
end
