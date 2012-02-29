module Exceptions
  class AccessError < StandardError; end
  class ShelterSuspended < AccessError; end
  class ApiIncorrectStatus < AccessError; end
  class ApiIncorrectType < AccessError; end
end
