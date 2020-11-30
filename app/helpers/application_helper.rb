require "uri"
require "net/http"

module ApplicationHelper
  @@base_url = "https://lyra-api.herokuapp.com/api/"
  
  def sanitize_and_save_html(item, html)
    # Ensures submitted html to DB is safe from XSS attacks
    sanitized_html = ActionController::Base.helpers.sanitize(html)
    item.update(html: sanitized_html)
    item.save
  end

  def find_and_save_tag(story, tag)
    tag = Tag.find_or_create_by(name: tag)
    story.update(tag: tag)
    story.save
  end

  # Takes care of establishing connection to Lyra API and posting/patching/deleting data
  def lyra_connection(item:, type:, method:, uuid: nil)
    url = URI(@@base_url + type)

    if method == 'patch' || method == 'delete'
      url = URI(@@base_url + type + "/" + uuid)
    end

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = establish_request(url, method)
    attach_data(type, request, item) if method == 'post' || method == 'patch'

    response = https.request(request)

    parse_and_save_uuid(response, item) if method == 'post'
  end

  private

  def establish_request(url, method)
    case method
    when 'post'
      request = Net::HTTP::Post.new url
    when 'patch'
      request = Net::HTTP::Patch.new url
    when 'delete'
      request = Net::HTTP::Delete.new url
    else
      request = Net::HTTP::Get.new url
    end

    request["Authorization"] = "Bearer "+ ENV['LYRA_API_KEY']

    request
  end 

  def attach_data(type, request, item)
    if type == 'newsletters'
      form_data = [['html', item.html],['date', item.formatted_date]]
    elsif type == 'stories'
      form_data = [['html', item.html],['title', item.title]]
    end

    request.set_form form_data, 'multipart/form-data'
  end

  def parse_and_save_uuid(response, item)
    parsed_response = JSON.parse(response.body)
    uuid = parsed_response["data"]["id"]
    item.uuid = uuid
    item.save
  end
end