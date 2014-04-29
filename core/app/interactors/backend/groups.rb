module Backend
  module Groups
    extend self
    def create(groupname:, members:)
      group = Group.new
      group.groupname = groupname
      group.users << members
      group.save!
      p group
      group #TODO: do we need a dead_group or something here?
    end

  end
end
