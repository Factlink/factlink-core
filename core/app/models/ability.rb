class Ability
  class AdminArea;end
  class FactlinkWebapp;end


  include CanCan::Ability

  attr_reader :user

  def signed_in?
    !!user
  end

  def initialize(user=nil)
    @user=user

    can :show, String do |template|
      ! /^home\/pages\/help/.match template
    end

    can :show, String

    define_anonymous_user_abilities

    define_comment_abilities
    define_sub_comment_abilities
    define_user_abilities
    define_user_activities_abilities
  end

  def define_anonymous_user_abilities
    can :read, Comment

    can :read, User do |u|
      u.active? || u.deleted # we show a special page for deleted users
    end
  end

  def define_comment_abilities
    return unless signed_in?

    can :read, Comment
    can :destroy, Comment do |comment|
      dead_comment = Backend::Comments.by_ids(ids: comment.id.to_s, current_graph_user_id: nil).first
      comment.created_by.id == user.id && dead_comment.is_deletable
    end
  end

  def define_sub_comment_abilities
    return unless signed_in?

    can :create, SubComment
    can :destroy, SubComment do |sub_comment|
      sub_comment.created_by_id == user.id
    end
  end

  def define_user_abilities
    return unless signed_in?

    can :read, user

    if user.admin?
      can :access, AdminArea
      can :configure, FactlinkWebapp
      can :manage, User
    end

    can :update, user
    can :destroy, user
  end

  def define_user_activities_abilities
    return unless signed_in?

    can :index, Activity
    can :see_activities, User do |u|
      u.id == user.id
    end
  end

  FEATURES = %w(
    log_jslib_loading_performance
    opinions_of_users_and_comments
  )
end
