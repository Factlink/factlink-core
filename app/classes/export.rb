class Export
  def export
    output = ''

    global_features(output)
    users(output)
    facts(output)
    comments(output)
    groups(output)

    output
  end

  private

  def global_features(output)
    output << import('FactlinkImport.global_features', features: Backend::GlobalFeatures.all.sort.join(' ')) + "\n"
  end

  def users(output)
    User.all.sort_by(&:username).each do |user|
      output << import('FactlinkImport.user', fields_from_object(user, User.import_export_simple_fields + [
        :encrypted_password, :confirmed_at, :confirmation_token, :confirmation_sent_at
      ]).merge(features: user.features.map(&:name).sort.join(' '))) + "\n"

      user.social_accounts.sort_by(&:provider_name).each do |social_account|
        output << import('FactlinkImport.social_account',
          fields_from_object(social_account, SocialAccount.import_export_simple_fields).merge(
            username: user.username)
        ) + "\n"
      end
    end

    User.all.sort_by(&:username).each do |follower|
      Pavlov.interactor(:'users/following', username: follower.username).sort_by(&:username).each do |followee|
        created_at = hack_to_get_following_time(follower_id: follower.id, followee_id: followee.id)

        output << import('FactlinkImport.follow', follower_username: follower.username,
          followee_username: followee.username, created_at: created_at) + "\n"
      end
    end
  end

  def facts(output)
    FactData.all.sort_by(&:fact_id).each do |fact_data|
      output << import('FactlinkImport.fact',
         {username: User.find(fact_data.created_by_id).username}.merge(
                       fields_from_object(fact_data, [
        :fact_id, :displaystring, :title, :url, :created_at
      ]).merge(fact_id: fact_data.fact_id.to_s))) + " do\n"

      sorted_votes = Backend::Facts.votes(fact_id: fact_data.fact_id).sort do |a, b|
        a[:username] <=> b[:username]
      end

      sorted_votes.each do |vote|
        output << '  '
        output << import('interesting', username: vote[:user].username)
        output << "\n"
      end

      output << "end\n"
    end
  end

  def comments(output)
    FactData.all.sort_by(&:fact_id).each do |fact_data|
      comment_sorter = lambda do |comment|
        comment.created_at.utc.to_s + comment.content + comment.created_by.username
      end

      comment_array = fact_data.comments
      comment_array.sort_by(&comment_sorter).each do |comment|
        output << import('FactlinkImport.comment',
          fields_from_object(comment, [:content, :created_at]).merge(
            fact_id: fact_data.fact_id.to_s, username: comment.created_by.username)
        ) + " do\n"

        Backend::Comments.opiniated(comment_id: comment.id.to_s, type: 'believes').to_a.sort_by(&:username).each do |believer|
          output << '  '
          output << import('opinion', opinion: 'believes', username: believer.username)
          output << "\n"
        end

        Backend::Comments.opiniated(comment_id: comment.id.to_s, type: 'disbelieves').to_a.sort_by(&:username).each do |disbeliever|
          output << '  '
          output << import('opinion', opinion: 'disbelieves', username: disbeliever.username)
          output << "\n"
        end

        comment.sub_comments.to_a.sort_by(&comment_sorter).each do |sub_comment|
          output << '  '
          output << import('sub_comment', fields_from_object(sub_comment, [:content, :created_at]).merge(
            username: sub_comment.created_by.username))
          output << "\n"
        end

        output << "end\n"
      end
    end
  end

  def groups(output)
    Group.all.sort_by(&:groupname).each do |group|
      output << import('FactlinkImport.group', fields_from_object(group, [:groupname])) + " do\n"

      group.users.sort_by(&:username).each do |user|
        output << '  '
        output << import('member', fields_from_object(user, [:username]))
        output << "\n"
      end

      output << "end\n"
    end
  end

  def hack_to_get_following_time(follower_id:, followee_id:)
    Following.where(follower_id: follower_id, followee_id: followee_id).first.created_at
  end

  def to_ruby(value)
    case value
    when Time
      return 'Time.parse(' + value.utc.iso8601.inspect + ')'
    when String, Integer, NilClass, TrueClass, FalseClass, Hash
      return value.inspect
    else
      fail "Unsupported type: " + value.class.name
    end
  end

  def name_value_to_string(name, value)
    name.to_s + ': ' + to_ruby(value) + ', '
  end

  def fields_from_object(object, field_names)
    field_names.inject({}) { |hash, name| hash.merge(name => object.public_send(name)) }
  end

  def import(import_name, fields)
    fields_string = fields.map{ |name, value| name_value_to_string(name, value)}.join

    "#{import_name}({#{fields_string}})"
  end
end
