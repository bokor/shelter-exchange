module AccountHelper

  def login
    account = Account.gen
    user    = account.users.first
    shelter = account.shelters.first 

    switch_to_subdomain(account.subdomain)
    login_with(user)

    [account, user, shelter]
  end

  def login_with(user)
    login_as(user, :scope => :user)
  end
end