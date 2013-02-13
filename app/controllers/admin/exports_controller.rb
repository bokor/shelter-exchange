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

  def petfinder_emails
    shelter_ids = Integration::Petfinder.all.map(&:shelter_id)
    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    respond_to do |format|
      format.csv{ send_data(petfinder_emails_csv(results),:filename => "petfinder_emails.csv") }
    end
  end

  def adopt_a_pet_emails
    shelter_ids = Integration::AdoptAPet.all.map(&:shelter_id)
    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    respond_to do |format|
      format.csv{ send_data(adopt_a_pet_emails_csv(results),:filename => "adopt_a_pet_emails.csv") }
    end
  end

  def all_integrations_emails
    shelter_ids = Integration.all.map(&:shelter_id)
    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    respond_to do |format|
      format.csv{ send_data(all_integrations_email_csv(results),:filename => "all_integration_emails.csv") }
    end
  end

  private
    def all_emails_csv(results)
      CSV.generate{|csv| results.collect(&:email).uniq.each{|email| csv << [email] } }
    end

    def petfinder_emails_csv(results)
      CSV.generate{|csv| results.collect(&:email).uniq.each{|email| csv << [email] } }
    end

    def adopt_a_pet_emails_csv(results)
      CSV.generate{|csv| results.collect(&:email).uniq.each{|email| csv << [email] } }
    end

    def all_integrations_email_csv(results)
      CSV.generate{|csv| results.collect(&:email).uniq.each{|email| csv << [email] } }
    end
end

#select distinct shelters.email from shelters
#left outer join integrations on integrations.shelter_id = shelters.id
#where integrations.type = 'Integration::Petfinder'
#union
#select distinct users.email from users
#left outer join accounts on accounts.id = users.account_id
#left outer join shelters on shelters.`account_id` = accounts.id
#left outer join integrations on integrations.shelter_id = shelters.id
#where integrations.type = 'Integration::Petfinder'
#

