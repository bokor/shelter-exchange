require 'csv'

class Admin::ExportsController < Admin::ApplicationController
  respond_to :html, :csv

  def index
  end

  def show
    csv_file = send(params[:export_type])

    respond_to do |format|
      format.csv{
        send_data(csv_file, :filename => "#{params[:export_type]}.csv")
      }
    end
  end

  #-----------------------------------------------------------------------------
  private

  def generate_csv_with_emails(results)
    CSV.generate{|csv| results.collect(&:email).uniq.each{|email| csv << [email] } }
  end

  # All Shelter and User Exports
  #----------------------------------------------------------------------------
  def all_emails
    results = Shelter.select('DISTINCT email').active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active"}).all

    generate_csv_with_emails(results)
  end

  # Integration Exports
  #----------------------------------------------------------------------------
  def petfinder_emails
    shelter_ids = Integration::Petfinder.all.map(&:shelter_id)
    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    generate_csv_with_emails(results)
  end

  def adopt_a_pet_emails
    shelter_ids = Integration::AdoptAPet.all.map(&:shelter_id)
    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    generate_csv_with_emails(results)
  end

  def all_integrations_emails
    shelter_ids = Integration.all.map(&:shelter_id)
    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    generate_csv_with_emails(results)
  end

  # Shelter Exports
  #----------------------------------------------------------------------------
  def signed_up_last_thirty_days_emails
    shelter_ids = Shelter.select(:id).where(:created_at, [Date.today..Date.today - 30.days])

    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
      User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    generate_csv_with_emails(results)
  end

  def never_used_before_emails
    shelter_ids = Shelter.select("DISTINCT(shelters.id)").
                          joins("LEFT OUTER JOIN animals on animals.shelter_id = shelters.id").
                          where("animals.shelter_id is NULL")
    results     = Shelter.select('DISTINCT email').
                          where(:id => shelter_ids).active.all +
                  User.select('DISTINCT users.email').
                       joins(:account => :shelters).
                       where(:shelters => {:status => "active", :id => shelter_ids}).all

    generate_csv_with_emails(results)
  end

  def not_used_past_thirty_days_emails
    shelter_ids = Shelter.select("DISTINCT(shelters.id)").
                          joins("LEFT OUTER JOIN animals on animals.shelter_id = shelters.id").
                          where("animals.shelter_id is NULL or animals.updated_at <= ?", Date.today - 30.days)

    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    generate_csv_with_emails(results)
  end

  # API Exports
  #----------------------------------------------------------------------------
  def web_token_emails
    shelter_ids = Shelter.select(:id).where("shelters.access_token IS NOT NULL")
    results = Shelter.select('DISTINCT email').where(:id => shelter_ids).active.all +
              User.select('DISTINCT users.email').joins(:account => :shelters).where(:shelters => {:status => "active", :id => shelter_ids}).all

    generate_csv_with_emails(results)
  end
end

