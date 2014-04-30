module Backend
  module Groups
    extend self
    def create(groupname:, usernames:)
      group = Group.new
      group.groupname = groupname
      group.users << User.where(username: usernames)
      group.save!
      group
    end
  end
end
