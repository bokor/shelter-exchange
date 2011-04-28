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

# def initialize(user)
#   if user.is?(:owner)
#     can :manage, :all
#   elsif user.is?(:admin)
#     can :manage, :all
#     cannot :change_owner, User
#   elsif user.is?(:user)
#     can [:read, :create, :update], :all
#     cannot :update, Shelter
#     cannot :generate_access_token, Shelter
#     cannot :invite, User
#     cannot :change_role, User
#     cannot :view_settings, User
#   end
#   
# end


