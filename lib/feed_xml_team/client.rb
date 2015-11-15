module FeedXmlTeam
  require 'httparty'

  class Client
    def initialize(username, password)
      @auth = { username: username, password: password}
      @dir = File.dirname __FILE__
    end

    def content_finder(options = {})
      begin
        response = HTTParty.get(
          FeedXmlTeam::Address.build(
            'feeds',
            options
          ),
          basic_auth: @auth
        )

        feed = JSON.parse response.body

        documents = []
        loop do
          feed['data']['document-listing'].each do |item|
            record = {}

            record[:file_path] = item['file-path']
            record[:fixture_key] = item['fixture-key']
            record[:publisher_key] = item['publisher-key']
            record[:original_modified_time] = item['original-modified-time']

            documents << record
          end

          if feed['metadata']['next'].blank?
            break
          else
            next_url = feed['metadata']['next']

            response = HTTParty.get(next_url, basic_auth: @auth)

            feed = JSON.parse response.body
          end

        end
      rescue => e
        raise e
      end

      documents
    end

    def get_document(options = {})
      response = HTTParty.get(
        FeedXmlTeam::Address.build(
          'get_document',
          options
        ),
        basic_auth: @auth
      )

      Nokogiri::XML(response.body)
    end

    def xml_to_json(item)


    end
  end
end
