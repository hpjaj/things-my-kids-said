class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :manage, User, id: user.id

      can :manage, Post, user_id: user.id

      can [:index, :read], Post do |post|
        post.author?(user) ||
        post.visible_to == Visibility::PUBLIC ||
        (
          user.kids.pluck(:id).include?(post.kid.id) &&
          Visibility.all_levels_without_me.include?(post.visible_to)
        ) ||
        (
          user.following.pluck(:id).include?(post.kid.id) &&
          Visibility.friends_and_public.include?(post.visible_to)
        )
      end

      can :create, Kid

      can :destroy, Comment do |comment|
        user.kids.pluck(:id).include?(comment.post.kid_id) || comment.user_id == user.id
      end

      can [:update, :destroy, :read, :index], Kid do |kid|
        kid.parents.pluck(:id).include? user.id
      end

      can :read, Kid do |kid|
        user.following.pluck(:id).include?(kid.id)
      end

      can :manage, Comment, user_id: user.id

      can :destroy, Comment do |comment|
        comment.post.kid.parents.pluck(:id).include?(user.id)
      end

      can :manage, FilteredKid, user_id: user.id

      can :manage, Picture, user_id: user.id

      can :destroy, Picture do |picture|
        user.kids.pluck(:id).include?(picture.kid_id) || picture.user_id == user.id
      end
    else
      can :read, Post do |post|
        post.visible_to == Visibility::PUBLIC
      end
    end
      # end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
