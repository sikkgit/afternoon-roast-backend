require "uri"
require "net/http"

class Story < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :newsletter, optional: true

  @@base_url = "https://lyra-api.herokuapp.com/api"

  def add_sanitized_html(html)
    self.html = ActionController::Base.helpers.sanitize(html)
    self.save
  end

  def post_to_lyra
    url = URI(@@base_url + "/stories")
    https = Net::HTTP.new(url.host, url.port); 
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Bearer "+ ENV['LYRA_API_KEY']

    form_data = [['html', self.html],['title', self.title]]
    request.set_form form_data, 'multipart/form-data'
    response = https.request(request)

    parsed_response = JSON.parse(response.body)
    uuid = parsed_response["data"]["id"]

    self.uuid = uuid
    self.save
  end
end



