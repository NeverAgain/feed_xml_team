module FeedXmlTeam
  class Address < Client

    def self.build(method, options = {})
      path = []

      default_start_range = 'PT5M'
      default_end_range = nil

      start_range = options[:start] || default_start_range
      end_range = options[:end] || default_end_range

      default_format = 'json'

      default_event_statuses = 'post-event'

      event_statuses = options[:event_statuses] || default_event_statuses

      # default_fixture_keys = 'event-summary'

      # fixture_keys = options[:fixture_keys] || default_fixture_keys

      default_publisher_keys = 'sportsforecaster.com'

      publisher_keys = options[:publisher_keys] || default_publisher_keys

      # not allowing format change for now
      # format = options[:format] || default_format

      fail 'Invalid method.' unless %w(feeds get_document).include? method

      if method == 'feeds'
        end_point = '/feeds?'

        # publisher identifier is not required
        # fail 'Must specify `publisher_id` (publisher-keys)' if options[:publisher_id].nil?

        path << "sport-keys=#{options[:sport_keys]}" if options[:sport_keys]

        # Publisher identifier
        path << "publisher-keys=#{publisher_keys}"

        # fail 'Must specify `league_id` (league-keys) or `team_id` (team-keys).' if options[:league_id].nil? && options[:team_id].nil?

        # League identifier
        path << "league-keys=#{options[:league_keys]}" if options[:league_keys]

        # Team identifier
        path << "team-keys=#{options[:team_keys]}" if options[:team_keys]

        # start range of the time specification
        path << "start=#{start_range}"

        # end range of the time specification
        path << "end=#{end_range}" unless end_range.nil?

        # type of data: roster, player movment etc
        fail 'Must specify `league_keys` if fixture_keys is specified' if options[:league_keys].nil? && !options[:fixture_keys].nil?

        path << "fixture-keys=#{options[:fixture_keys]}" if options[:fixture_keys] && options[:league_keys]

        # event status. only retrieving post-event for now as I don't have mid-event
        # for testing
        path << "event-statuses=#{event_statuses}"

        # using json as default formatting since I'm too busy to write a parser for
        # xml and others
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
