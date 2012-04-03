module Exceptions
  class AccessError < StandardError; end
  class ShelterInactive < AccessError; end
  class ApiIncorrectTypeStatus < AccessError; end
end
