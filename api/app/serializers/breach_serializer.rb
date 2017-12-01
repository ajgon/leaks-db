# frozen_string_literal: true

class BreachSerializer < ActiveModel::Serializer
  attributes :breach_date, :compromised_accounts, :compromised_data, :description, :domain, :slug, :title
  attribute :data_uri, key: :logo
end
