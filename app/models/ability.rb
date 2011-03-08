class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is?(:owner)
      can :manage, :all
    elsif user.is?(:admin)
      can :manage, :all
    elsif user.is?(:user)
      can [:read, :update], :all
      cannot :update, Shelter
    end
  end
  
end


# alias_action :index, :show, :to => :read
# alias_action :new, :to => :create
# alias_action :edit, :to => :update

# alias_action :read, :create, :update, :to => :modify

