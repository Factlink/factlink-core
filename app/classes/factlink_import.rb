module FactlinkImport
  extend self

  class FactlinkImportFact
    def initialize(fact_id)
      @fact_id = fact_id
    end

    def interesting(fields)
      ExecuteAsUser.new(FactlinkImport.user_for(fields[:username])).execute do |pavlov|
        pavlov.import = true
        pavlov.time = nil
        dead_fact = pavlov.interactor(:'facts/set_interesting', fact_id: @fact_id)
      end
    end
  end

  class FactlinkImportComment
    def initialize(comment_id)
      @comment_id = comment_id
    end

    def sub_comment(fields)
      ExecuteAsUser.new(FactlinkImport.user_for(fields[:username])).execute do |pavlov|
        pavlov.import = true
        pavlov.time = fields[:created_at]
        dead_fact = pavlov.interactor(:'sub_comments/create', comment_id: @comment_id,
          content: fields[:content])
      end
    end

    def opinion(fields)
      ExecuteAsUser.new(FactlinkImport.user_for(fields[:username])).execute do |pavlov|
        pavlov.import = true
        pavlov.time = nil
        dead_fact = pavlov.interactor(:'comments/update_opinion', comment_id: @comment_id,
          opinion: fields[:opinion])
      end
    end
  end

  class FactlinkImportGroup
    def initialize(group)
      @group = group
    end

    def member(fields)
      ExecuteAsUser.new(nil).execute do |pavlov|
        pavlov.import = true
        pavlov.time = nil
        pavlov.interactor(:'groups/add_member', username: fields[:username], group_id: @group.id)
      end
    end
  end

  def global_features(fields)
    Backend::GlobalFeatures.set fields[:features].split(' ')
  end

  def user(fields)
    user = User.new

    User.import_export_simple_fields.each do |name|
      user.public_send("#{name}=", fields[name])
    end
    user.password = "some_dummy" # before setting encrypted_password
    user.encrypted_password = fields[:encrypted_password]
    user.skip_confirmation_notification!
    user.save!

    fields[:features].split(' ').each do |feature|
      user.features << Feature.create!(name: feature)
    end

    user.confirmed_at = fields[:confirmed_at]
    user.confirmation_token = fields[:confirmation_token]
    user.confirmation_sent_at = fields[:confirmation_sent_at]
    user.save!

    # set here again explicitly, without other assignments, to prevent overwriting
    user.updated_at = fields[:updated_at]
    user.save!
  end

  def social_account(fields)
    create_fields = fields.slice(*SocialAccount.import_export_simple_fields)
    create_fields[:user_id] = user_for(fields[:username]).id.to_s
    SocialAccount.create! create_fields
  end

  def fact(fields, &block)
    dead_fact = nil
    ExecuteAsUser.new(user_for(fields[:username])).execute do |pavlov|
      pavlov.import = true
      pavlov.time = fields[:created_at]
      dead_fact = pavlov.interactor(:'facts/create', fact_id: fields[:fact_id],
        displaystring: fields[:displaystring], site_title: fields[:title],
        site_url: fields[:url])
    end

    FactlinkImportFact.new(dead_fact.id).instance_eval(&block)
  end

  def comment(fields, &block)
    dead_comment = nil
    ExecuteAsUser.new(user_for(fields[:username])).execute do |pavlov|
      pavlov.import = true
      pavlov.time = fields[:created_at]
      dead_comment = pavlov.interactor(:'comments/create', fact_id: fields[:fact_id], content: fields[:content])
    end

    FactlinkImportComment.new(dead_comment.id).instance_eval(&block)
  end

  def group(fields, &block)

    group = nil

    ExecuteAsUser.new(nil).execute do |pavlov|
      pavlov.import = true
      group = pavlov.interactor(:'groups/create', groupname: fields[:groupname], members: [])
    end

    FactlinkImportGroup.new(group).instance_eval(&block)

  end

  def follow(fields)
    ExecuteAsUser.new(user_for(fields[:follower_username])).execute do |pavlov|
      pavlov.import = true
      pavlov.time = fields[:created_at]
      pavlov.interactor(:'users/follow_user', username: fields[:followee_username])
    end
  end

  def user_for(username)
    @user_for ||= {}
    @user_for[username] ||= Backend::Users.user_by_username(username: username) or fail "Username '#{username}' not found"
  end
end
