module FeedXmlTeam
  require 'httparty'
  require 'nokogiri'

  class Client
    def initialize(username, password)
      @auth = { username: username, password: password}
      @dir = File.dirname __FILE__
    end

    def content_finder(options = {})
      response = HTTParty.get(
        FeedXmlTeam::Address.build(
          'feeds',
          options
        ),
        basic_auth: @auth
      )

      feed = Nokogiri::XML(response.body)
    end
end
