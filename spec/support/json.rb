module JSONUtils
  def response_body
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include JSONUtils
end
