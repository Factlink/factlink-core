module Backend
  module Users
    extend self

    # This query returns dead user objects, retrieved by their ids
    # You have the option to call it with mongo ids, or with (Ohm) GraphUser
    # ids.
    # Please try to avoid to add support for all other kinds of fields,
    # both because we want it to have an index, and because we don't want to
    # leak too much of the internals
    def by_ids(user_ids:, by: nil)
      by ||= :_id
      user_ids = Array(user_ids)

      fail "invalid id type: #{by}" unless [:_id, :graph_user_id].include? by


      User.any_in(by => user_ids).map do |user|
        DeadUser.new \
          id: user.id.to_s,
          name: user.name,
          username: user.username,
          gravatar_hash: user.gravatar_hash,
          deleted: user.deleted
      end
    end
  end
end
