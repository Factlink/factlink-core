module Backend
  module Facts
    extend self
    def create(groupname:, members:)
      group = Group.new
      group.groupname = groupname
      group.users << members

      group #TODO: do we need a dead_group or something here?
    end

  end
end
