class Ability
  include CanCan::Ability

  def initialize(user)
    send(user.role) rescue send("read_only")
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
    cannot :export, Animal
    cannot :export, Contact
    cannot :import, Contact
    cannot :attach_files, Note
    cannot :update, Shelter
    cannot :generate_access_token, Shelter
    cannot :destroy, StatusHistory
    cannot :invite, User
    cannot :change_role, User
    cannot :view_settings, User
    cannot :export_data, User
  end

  def read_only
    cannot :manage, :all
    can :update, User
  end
end

