require 'pavlov'

class FactlinkUser < Pavlov::Entity
  attributes :id, :name, :username, :location, :biography,
    :gravatar_hash, :email, :receives_mailed_notifications

  def self.attributes
    @attributes
  end

  def self.map_from_mongoid document
    result = {}
    FactlinkUser.attributes.each {|attribute| result[attribute] = document.send(attribute) if document.respond_to? attribute }
    new result
  end
end
