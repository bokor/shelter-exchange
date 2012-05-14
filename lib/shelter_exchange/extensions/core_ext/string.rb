class String
  
  def is_numeric?
    begin Float(self) ; true end rescue false
  end
  
  def possessive
    (self[-1,1] == "s") ? self + "'" : self + "'s"
  end
  
end