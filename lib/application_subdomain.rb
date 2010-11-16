class ApplicationSubdomain
  
  def self.matches?(request)
    subdomain_list = ["www", "support", "blog", "wiki", "billing", "help", "api", "authenticate", "launchpad", "forum", "admin", "user", "login", "logout", "signup", "register", "mail", "ftp", "pop", "smtp", "ssl", "sftp"]
    request.subdomain.present? && !subdomain_list.include?(request.subdomain)
  end
  
end