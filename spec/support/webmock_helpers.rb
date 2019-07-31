# The 'stub_service' helper can be used to stub out external services to return the contents of a
# fixture file, or any other response body. When used without arguments, `stub_service(:facebook)`,
# it will open the file at spec/fixtures/services/facebook, and return its contents with status 200
# for all requests to the endpoint specified in the SERVICES hash. Various options can be overriden
# when using this method to override method, headers, etc.

module WebmockHelpers
  SERVICES = {
    contentful_recipes_entries: { url: 'https://cdn.contentful.com/spaces/SPACE-ID/entries?sys.contentType.sys.id=recipe' },
    contentful_recipe_entries: { url: %r{https://cdn.contentful.com/spaces/SPACE-ID/entries\?sys.contentType.sys.id=recipe&sys.id=.+} }
  }.freeze

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ParameterLists, Metrics/LineLength
  # This method isn't very pretty, but we feel like abstracting it further wouldn't make it easier
  # to understand and use, so we make some linting exceptions.
  def stub_service(name, status: 200, method: nil, headers: {}, with: nil, response_body: nil, response_fixture: nil)
    service = SERVICES.fetch(name)
    raise "No service #{name}" unless service.present?

    response_body = load_fixture(response_fixture || name) if response_body.nil?
    headers = service[:default_headers] if headers.blank?
    request_method = method || service[:default_method] || :get

    stub = stub_request(request_method, service[:url])
    stub.with(with) if with.present?
    stub.to_return(status: status, body: response_body, headers: headers)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ParameterLists, Metrics/LineLength

  def assert_service_requested(name, method: nil, with: nil)
    service = SERVICES.fetch(name)
    request_method = method || service[:default_method] || :get

    stub = a_request(request_method, service[:url])
    stub = stub.with(with) if with.present?
    expect(stub).to have_been_made
  end

  def assert_service_not_requested(name, method: nil)
    service = SERVICES.fetch(name)
    request_method = method || service[:default_method] || :get
    expect(a_request(request_method, service[:url])).not_to have_been_made
  end

  def load_fixture(fixture)
    filepath = File.join('spec', 'fixtures', 'services', fixture.to_s)
    File.read(filepath).strip
  end
end

RSpec.configure do |config|
  config.include WebmockHelpers
end
