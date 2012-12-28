require 'spec_helper'

describe 'Home Page', :js => :true do
  it 'welcomes the user' do
    @animal = Animal.gen
    puts @animal.name
    visit root_path
    should_be_on '/'
    page.should have_content('Welcome')
  end
end