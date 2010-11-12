module BreedsHelper

  def format_breed(is_mix_breed, primary_breed, secondary_breed)
    breeds_text = ""
    if is_mix_breed
		  breeds_text = primary_breed.to_s + " & " + secondary_breed.to_s + " Mix"
		else 
		  breeds_text = primary_breed.to_s
		end
  end

end