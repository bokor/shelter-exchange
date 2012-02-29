class Admin::ExportsController < Admin::ApplicationController
  require 'csv'
  respond_to :html, :js, :csv
  
  def index
  end
  
  def all_emails
    results = Shelter.select('DISTINCT email').active + 
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active"})
    respond_to do |format|       
      format.csv{ send_data(all_emails_csv(results),:filename => "shelters_and_users_emails.csv") }
    end
  end
  
  private
    def all_emails_csv(results)
      CSV.generate{|csv| results.each{|v| csv << [v.email] }}
    end
  
end