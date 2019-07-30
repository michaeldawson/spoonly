# Interface with the contentful API
class ContentfulAPI
  attr_reader :space_id, :environment_id, :access_token

  BASE_URL = 'https://cdn.contentful.com'.freeze

  class NetworkError < StandardError; end

  def self.default
    new(
      ENV.fetch('CONTENTFUL_SPACE_ID'),
      ENV.fetch('CONTENTFUL_ENVIRONMENT_ID'),
      ENV.fetch('CONTENTFUL_ACCESS_TOKEN')
    )
  end

  def initialize(space_id, environment_id, access_token)
    @space_id = space_id
    @environment_id = environment_id
    @access_token = access_token
  end

  def recipe_entries(id = nil)
    api_request(
      'entries',
      query: {
        'sys.id' => id,
        'sys.contentType.sys.id' => 'recipe'
      }.compact
    )
  end

  private

  def api_request(path, query: {})
    url = "#{BASE_URL}/spaces/#{space_id}/#{path}"
    response = HTTParty.get(url, headers: headers, query: query)

    raise NetworkError, response.code unless response.success?

    JSON.parse(response.body)
  end

  def headers
    @headers ||= {
      Authorization: "Bearer #{access_token}",
      Accept: 'application/json'
    }
  end
end
