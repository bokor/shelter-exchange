module MailerHelper
  def extract_token_from_email(body, token_name)
    body.to_s[/#{token_name.to_s}_token=([^"]+)/, 1]
  end
end

