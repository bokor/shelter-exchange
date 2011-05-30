module Exceptions
  class AccessError < StandardError; end
  class AccountBlocked < AccessError; end
end
