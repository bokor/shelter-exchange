class Ability
  include CanCan::Ability

  def initialize(user)
    send(user.role)
  end

  def owner
    can :manage, :all
  end

  def admin
    can :manage, :all
    # cannot :destroy, Animal
    cannot :change_owner, User
  end
    
  def user
    can [:read, :create, :update], :all
    cannot :update, Shelter
    cannot :generate_access_token, Shelter
    cannot :invite, User
    cannot :change_role, User
    cannot :view_settings, User
    cannot :request_transfer, Animal
  end
  
end

