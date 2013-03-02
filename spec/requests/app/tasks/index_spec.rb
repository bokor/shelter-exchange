require 'spec_helper'

describe 'Task - Index Page', :js => :true do

  before do
    @account, @user, @shelter = create_account
    @subdomain = @account.subdomain
  end

  it 'should show the correct page title' do
    task = Task.gen
    visit tasks_path(:subdomain => @subdomain)
    page.should have_content('Tasks')
  end

  it 'should redirect to new page when there are no tasks' do
    visit tasks_path(:subdomain => @subdomain)
    @shelter.tasks.count.should == 0
    page.should have_content('Create your first task')
  end

end

  #def index
    #@overdue_tasks =  @current_shelter.tasks.overdue.active.includes(:taskable).all
    #@today_tasks = @current_shelter.tasks.today.active.includes(:taskable).all
    #@tomorrow_tasks = @current_shelter.tasks.tomorrow.active.includes(:taskable).all
    #@later_tasks = @current_shelter.tasks.later.active.includes(:taskable).all

    #if @overdue_tasks.blank? and @today_tasks.blank? and @tomorrow_tasks.blank? and @later_tasks.blank?
      #redirect_to new_task_path
    #end
  #end

