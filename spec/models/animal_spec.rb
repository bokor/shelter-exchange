require "spec_helper"

describe Animal do
  it_should_behave_like Statusable
  it_should_behave_like Typeable
  it_should_behave_like Uploadable

end
