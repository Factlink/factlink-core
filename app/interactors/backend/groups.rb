module Backend
  module Groups
    extend self
    def create(groupname:, usernames:)
      group = Group.new
      group.groupname = groupname
      group.users << usernames.map{ |username| User.where(username: username).first }
      group.save!
      group #TODO: do we need a dead_group or something here?
    end

  end
end
