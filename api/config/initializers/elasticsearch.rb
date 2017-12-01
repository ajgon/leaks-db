# frozen_string_literal: true

require 'elasticsearch/persistence/model'

Elasticsearch::Persistence.client = Elasticsearch::Client.new(
  YAML.safe_load(ERB.new(File.read("#{Rails.root}/config/elasticsearch.yml")).result)[Rails.env].deep_symbolize_keys
)
