module FeedXmlTeam
  class Address < Client

    def self.build(method, options = {})
      path = []

      default_start_range = 'PT5M'
      default_end_range = nil

      start_range = options[:start] || default_start_range
      end_range = options[:end] || default_end_range

      default_format = 'json'

      # not allowing format change for now
      # format = options[:format] || default_format

      fail 'Invalid method.' unless %w(feeds get_document).include? method

      if method == 'feeds'
        end_point = '/feeds?'

        # publisher identifier is not required
        # fail 'Must specify `publisher_id` (publisher-keys)' if options[:publisher_id].nil?

        # Publisher identifier
        path << "publisher-keys=#{options[:publisher_keys]}"

        fail 'Must specify `league_id` (league-keys) or `team_id` (team-keys).' if options[:league_id].nil? && options[:team_id].nil?

        # League identifier
        path << "league-keys=#{options[:league_keys]}" if options[:league_id]

        # Team identifier
        path << "team-keys=#{options[:team_keys]}" if options[:team_id]

        path << "start=#{start_range}"

        unless end_range.nil?
          path << "end=#{end_range}"
        end

        if options[:fixture_keys]
          path << "fixture-keys=#{options[:fixture_keys]}"
        end

        path << "format=#{default_format}"
      else
        end_point = '/sportsml/files/'

        if options[:file_path]
          path << options[:file_path]
        else
          fail 'Missing `file_path`'
        end
      end

      path_str = path.join '&'

      return FeedXmlTeam::API_BASE_URL + end_point + path_str
    end
  end
end
