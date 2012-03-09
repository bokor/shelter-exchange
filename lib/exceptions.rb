module Exceptions
  class AccessError < StandardError; end
  class ShelterInactive < AccessError; end
  class ApiIncorrectStatus < AccessError; end
  class ApiIncorrectType < AccessError; end
end
