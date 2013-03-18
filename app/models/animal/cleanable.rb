module Animal::Cleanable
  extend ActiveSupport::Concern

  included do
    before_save :clean_fields
  end


  #----------------------------------------------------------------------------
  private

  def clean_fields
    clean_description
    clean_secondary_breed
    clean_special_needs
  end

  def clean_description
    # Remove Microsoft Extra Smart Formatting
    unless self.description.blank?
      self.description.strip!
      self.description.gsub!(/[\u201C\u201D\u201E\u201F\u2033\u2036]/, '"')
      self.description.gsub!(/[\u2018\u2019\u201A\u201B\u2032\u2035\uFFFD]/, "'")
      self.description.gsub!(/[\u2013\u2014]/, "-")
      self.description.gsub!(/\u02C6/, '^')
      self.description.gsub!(/\u2039/, '<')
      self.description.gsub!(/\u203A/, '>')
      self.description.gsub!(/\u2013/, '-')
      self.description.gsub!(/\u2014/, '--')
      self.description.gsub!(/\u2026/, '...')
      self.description.gsub!(/\u00A9/, '&copy;')
      self.description.gsub!(/\u00AE/, '&reg;')
      self.description.gsub!(/\u2122/, '&trade;')
      self.description.gsub!(/\u00BC/, '&frac14;')
      self.description.gsub!(/\u00BD/, '&frac12;')
      self.description.gsub!(/\u00BE/, '&frac34;')
      self.description.gsub!(/[\u02DC\u00A0]/, " ")
    end
  end

  def clean_secondary_breed
    self.secondary_breed = nil unless self.mix_breed?
  end

  def clean_special_needs
    self.special_needs = nil unless self.special_needs?
  end
end

