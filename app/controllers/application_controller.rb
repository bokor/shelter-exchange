class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  protected
    def is_integer(test)
      test =~ /\A-?\d+\Z/
    end

end
