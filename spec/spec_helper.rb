require 'simplecov'
SimpleCov.start 'rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around :each, elasticsearch: true do |example|
    [Project, Repository, Issue].each do |model|
      model.__elasticsearch__.create_index!(force: true)
      model.__elasticsearch__.refresh_index!
    end
    example.run
    [Project, Repository, Issue].each do |model|
      model.__elasticsearch__.client.indices.delete index: model.index_name
    end
  end
end
