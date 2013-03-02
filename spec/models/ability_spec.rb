require "spec_helper"

describe Ability, ".owner" do
  def owner
    can :manage, :all
  end
end

describe Ability, ".admin" do
  def admin
    can :manage, :all
    # cannot :destroy, Animal
    cannot :change_owner, User
  end
end

describe Ability, ".user" do
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

