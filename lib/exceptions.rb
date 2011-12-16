module Exceptions
  class AccessError < StandardError; end
  class AccountBlocked < AccessError; end
  class ApiIncorrectStatus < AccessError; end
  class ApiIncorrectType < AccessError; end
end
