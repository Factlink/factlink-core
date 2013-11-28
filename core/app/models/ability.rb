class Ability
  class AdminArea;end
  class FactlinkWebapp;end


  include CanCan::Ability

  attr_reader :user

  def signed_in?
    !!user
  end

  def set_up?
    signed_in? and user.set_up
  end

  def initialize(user=nil)
    @user=user

    can :show, String do |template|
      ! /^home\/pages\/help/.match template
    end

    if set_up?
      can :access, FactlinkWebapp
      can :show, String
    end

    define_anonymous_user_abilities

    define_feature_toggles

    define_channel_abilities
    define_fact_abilities
    define_fact_relation_abilities
    define_comment_abilities
    define_sub_comment_abilities
    define_user_abilities
    define_user_favourites_abilities
    define_user_activities_abilities
    define_sharing_abilities
  end

  def define_anonymous_user_abilities
    can :get_fact_count, Site
    can :new, Fact
    can :index, Fact
    can :read, Fact
    can :read, FactRelation
    can :read, Comment
    can :read, Channel
    can :read, Topic

    can :read, User do |u|
      u.active? || u.deleted # we show a special page for deleted users
    end
  end

  def define_channel_abilities
    return unless signed_in?
    can :manage, Channel do |ch|
      ch.created_by_id == user.graph_user_id
    end
  end

  def define_fact_abilities
    return unless signed_in?

    can :index, Fact
    can :read, Fact
    can :opinionate, Fact
    can :add_evidence, Fact
    can :manage, Fact do |f|
      f.created_by_id == user.graph_user_id
    end
    cannot :update, Fact
  end

  def define_fact_relation_abilities
    return unless signed_in?

    can :read, FactRelation
    can :opinionate, FactRelation
    can :destroy, FactRelation do |fr|
      fr.created_by_id == user.graph_user_id && fr.deletable?
    end
  end

  def define_comment_abilities
    return unless signed_in?

    can :read, Comment
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
    can :set_up, user

    if set_up?
      if user.admin?
        can :access, AdminArea
        can :configure, FactlinkWebapp
        can :manage, User
        cannot :edit_settings, User
      end

      if user.has_invitations_left?
        can :invite, User
      else
        cannot :invite, User
      end

      can :update, user
      can :edit_settings, user
      can :destroy, user
    end
  end

  def define_user_favourites_abilities
    return unless signed_in?

    can :show_favourites, user
    can :edit_favourites, user
  end

  def define_user_activities_abilities
    return unless signed_in?

    can :index, Activity
    can :mark_activities_as_read, User do |u|
      u.id == user.id
    end
    can :see_activities, User do |u|
      u.id == user.id
    end
  end

  def define_sharing_abilities
    return unless signed_in?

    can :share, Fact

    can :share_to, SocialAccount do |social_account|
      social_account.persisted? && social_account.user == user
    end
  end

  FEATURES = %w(
    pink_feedback_button skip_create_first_factlink memory_profiling
    sees_channels share_discussion_buttons suppress_double_scrollbar
    comments_no_opinions
  )

  def enabled_global_features
    Pavlov.interactor :'global_features/all'
  end

  def enable_features list
    list.each do |feature|
      can :"see_feature_#{feature}", FactlinkWebapp
      @features << feature.to_s
    end
  end

  def define_feature_toggles
    @features ||= []
    enable_features enabled_global_features
    if signed_in?
      enable_features user.features
    end
  end

  def feature_toggles
    return @features
  end

end
