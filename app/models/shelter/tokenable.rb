module Shelter::Tokenable
  extend ActiveSupport::Concern

  included do

    validates :access_token, :uniqueness => true, :on => :generate_access_token!

    scope :by_access_token, lambda { |access_token| where(:access_token => access_token) }

  end

  def generate_access_token!
    self.access_token = SecureRandom.hex(15)
    save!
  end
end

