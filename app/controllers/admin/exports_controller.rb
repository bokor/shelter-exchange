require 'csv'

class Admin::ExportsController < Admin::ApplicationController
  respond_to :html, :csv

  def index
  end

  def show
    results = send(params[:export_type])

    csv_string = CSV.generate do |csv|
      results.collect(&:email).uniq.each{|email| csv << [email] }
    end

    respond_to do |format|
      format.csv {
        send_data(csv_string,
          :type => "text/csv",
          :filename => "#{params[:export_type]}.csv"
        )
      }
    end
  end

  #-----------------------------------------------------------------------------
  private

  # All Shelter and User Exports
  #----------------------------------------------------------------------------
  def all_emails
    Shelter.select(:email).active +
    User.select(:"users.email").joins(:account => :shelters).where(:shelters => { :status => "active" })
  end

  # Integration Exports
  #----------------------------------------------------------------------------
  def petfinder_emails
    shelter_ids = Integration::Petfinder.all.map(&:shelter_id)

    Shelter.select(:email).where(:id => shelter_ids).active +
    User.select(:"users.email").joins(:account => :shelters).where(:shelters => { :status => "active", :id => shelter_ids })
  end

  def adopt_a_pet_emails
    shelter_ids = Integration::AdoptAPet.all.map(&:shelter_id)

    Shelter.select(:email).where(:id => shelter_ids).active +
    User.select(:"users.email").joins(:account => :shelters).where(:shelters => { :status => "active", :id => shelter_ids })
  end

  def all_integrations_emails
    shelter_ids = Integration.all.map(&:shelter_id)

    Shelter.select(:email).where(:id => shelter_ids).active +
    User.select(:"users.email").joins(:account => :shelters).where(:shelters => { :status => "active", :id => shelter_ids })
  end

  # Shelter Exports
  #----------------------------------------------------------------------------
  def signed_up_last_thirty_days_emails
    shelter_ids = Shelter.select(:id).where(:created_at => Time.zone.today-30.days..Time.zone.today).active

    Shelter.select(:email).where(:id => shelter_ids) +
    User.select(:"users.email").joins(:account => :shelters).where(:shelters => { :id => shelter_ids })
  end

  def not_used_past_thirty_days_emails
    active_shelter_ids = []

    Shelter.active.includes(:users).each do |shelter|
      shelter.users.each do |user|
        if user.current_sign_in_at && user.current_sign_in_at > 30.days.ago
          active_shelter_ids << shelter.id
          break
        end
      end
    end

    non_active_shelter_ids = Shelter.select(:id).active.where("ID NOT IN (?)", active_shelter_ids)

    Shelter.select(:email).where(:id => non_active_shelter_ids) +
    User.select(:"users.email").joins(:account => :shelters).where(:shelters => { :id => non_active_shelter_ids })
  end

  # API Exports
  #----------------------------------------------------------------------------
  def web_token_emails
    shelter_ids = Shelter.select(:id).where("shelters.access_token IS NOT NULL").active.all

    Shelter.select(:email).where(:id => shelter_ids) +
    User.select(:"users.email").joins(:account => :shelters).where(:shelters => { :id => shelter_ids })
  end
end

