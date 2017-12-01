# frozen_string_literal: true

class Breach < ElasticsearchRecord
  include Elasticsearch::Persistence::Model
  include ActiveModel::Validations::Callbacks

  attribute :title, String
  attribute :slug, String
  attribute :domain, String
  attribute :breach_date, Date
  attribute :compromised_accounts, Integer
  attribute :description, String
  attribute :compromised_data, Array[String]
  attribute :logo, Hash, mapping: {
    type: 'object',
    properties: { mime_type: { type: 'text' }, data: { type: 'binary' } }
  }
  attribute :haveibeenpwned, Hash, mapping: {
    type: 'object',
    properties: {
      verified: { type: 'boolean' }, fabricated: { type: 'boolean' }, sensitive: { type: 'boolean' },
      active: { type: 'boolean' }, retired: { type: 'boolean' }, spam_list: { type: 'boolean' }
    }
  }

  validates :title, presence: true

  acts_as_url :title, url_attribute: :slug

  def data_uri
    "data:#{logo['mime_type']},base64;#{logo['data']}"
  end
end
