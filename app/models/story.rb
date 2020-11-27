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

  def sanitize_and_update_html(html)
    sanitized_html = ActionController::Base.helpers.sanitize(html)
    self.update(html: sanitized_html)
    self.save
  end

  def lyra_connection(http_method, uuid = nil)
    uri_string = @@base_url + "/stories"
    url = URI(uri_string)

    if http_method == 'patch' || http_method == 'delete'
      url = URI(uri_string + "/" + uuid)
    end
    
    https = Net::HTTP.new(url.host, url.port); 
    https.use_ssl = true

    if http_method == 'post'
      request = Net::HTTP::Post.new(url)
    elsif http_method == 'patch'
      request = Net::HTTP::Patch.new(url)
    elsif http_method == 'delete'
      request = Net::HTTP::Delete.new(url)
    end

    request["Authorization"] = "Bearer "+ ENV['LYRA_API_KEY']

    if http_method == 'post' || http_method == 'patch'
      form_data = [['html', self.html],['title', self.title]]
      request.set_form form_data, 'multipart/form-data'
    end
    
    response = https.request(request)

    if http_method == 'post'
      parsed_response = JSON.parse(response.body)
      uuid = parsed_response["data"]["id"]
      self.uuid = uuid
      self.save
    end

  end

end



