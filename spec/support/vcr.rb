VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :none, erb: true }
  config.hook_into :webmock
end
