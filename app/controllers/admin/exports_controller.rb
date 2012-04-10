class Admin::ExportsController < Admin::ApplicationController
  require 'csv'
  respond_to :html, :js, :csv
  
  def index
  end
  
  def all_emails
    results = Shelter.select('DISTINCT email').active.all + 
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active"}).all
              
    respond_to do |format|       
      format.csv{ send_data(all_emails_csv(results),:filename => "shelters_and_users_emails.csv") }
    end
  end
  
  private
    def all_emails_csv(results)
      CSV.generate{|csv| results.collect(&:email).uniq.each{|email| csv << [email] } }
    end
  
end
