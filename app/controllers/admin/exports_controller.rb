class Admin::ExportsController < Admin::ApplicationController
  require 'csv'
  respond_to :html, :js, :csv
  
  def index
  end
  
  def all_emails
    results = Shelter.select('DISTINCT email') + User.select('DISTINCT email')
    respond_to do |format|       
      format.csv{ send_data(all_emails_csv(results),:filename => "shelters_and_users_emails.csv") }
    end
  end
  
  private
    def all_emails_csv(results)
      CSV.generate{|csv| results.each{|v| csv << [v.email] }}
    end
  
end