require 'spec_helper'

describe 'Home Page', :js => :true do

  before do
    # @account, @user, @shelter = create_account
  end

  it 'tests' do
    Shelter.gen
    Shelter.gen
    # test = Delayed::Worker.new.work_off
    # puts test.to_json
    # puts ActionMailer::Base.deliveries
    visit root_path
    # debugger

    # page.should have_content('shelterexchange-test')

  end

  it 'blah' do
    @animal = Animal.gen(:shelter => Shelter.gen)
    visit public_save_a_life_path(@animal, :subdomain => "www")
    page.should have_content('shelterexchange-test')
  end
  # it 'welcomes the user' do
  #   @animal = Animal.gen
  #   puts @animal.name

  #   @account = Account.gen

  #   user_1   = @account.users.first
  #   user_2   = User.gen(:account_id =>@account.id)
  #   user_3   = User.gen(:account_id =>@account.id)
  #   puts @account.shelters.first.to_json
  #   puts user_1.to_json
  #   puts user_2.to_json
  #   puts user_3.to_json

  #   visit root_path
  #   should_be_on '/'
  #   page.should have_content('Welcome')
  # end
end