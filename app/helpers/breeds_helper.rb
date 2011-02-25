module BreedsHelper

  def format_breed(is_mix_breed, primary_breed, secondary_breed)
    breeds_text = primary_breed
    if is_mix_breed
      breeds_text = secondary_breed.blank? ? primary_breed << " Mix" : primary_breed << " & " << secondary_breed << " Mix"
		end
  end

end