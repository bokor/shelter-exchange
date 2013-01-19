require 'spec_helper'

describe 'Save a Life', :js => :true do

  before do
    @account, @user, @shelter = login
  end

  it 'dashboard' do
    visit root_path
    # page.should have_content('shelterexchange-test')
    # test = Delayed::Worker.new.work_off
    # puts test.to_json
    # puts ActionMailer::Base.deliveries
    # visit public_save_a_life_index_path
    # debugger

    # page.should have_content('shelterexchange-test')

  end

  it 'animals' do
    @animal_1 = Animal.gen!(:shelter => @shelter)
    @animal_2 = Animal.gen!(:shelter => @shelter)

    visit animals_path
    page.should have_content('Billy Bob')
    # test = Delayed::Worker.new.work_off
    # puts test.to_json
    # puts ActionMailer::Base.deliveries
    # visit public_save_a_life_index_path
    # debugger

    # page.should have_content('shelterexchange-test')

  end

end

