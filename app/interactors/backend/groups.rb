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

    def add_member(username:, groupname:)
      user = Users.user_by_username username: username
      group = group_by_groupname groupname: groupname
      group.users << user
      group.save!
    end

    def group_by_groupname(groupname:)
      Group.find_by! groupname: groupname
    end
  end
end
