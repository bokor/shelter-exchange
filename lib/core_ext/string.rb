class String

  def is_numeric?
    begin Float(self) ; true end rescue false
  end

  def possessive
    (self[-1,1] == "s") ? self + "'" : self + "'s"
  end

  def to_boolean
    return true if ['true', '1', 'yes', 'on', 't'].include? self
    return false if ['false', '0', 'no', 'off', 'f'].include? self
    return nil
  end
end

