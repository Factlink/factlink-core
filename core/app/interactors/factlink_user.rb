require 'pavlov'

class FactlinkUser < Pavlov::Entity
  attributes :id, :name, :username, :location, :biography,
    :gravatar_hash, :email, :receives_mailed_notifications

  def self.attributes
    @attributes
  end

  def self.map_from_mongoid_document
    result = {}
    FactlinkUser.attributes.each {|attribute| result[attribute] = mongoid_user.send(attribute) if mongoid_user.respond_to? attribute }
    new result
  end
end
