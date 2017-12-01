# frozen_string_literal: true

class FetchBreachesService
  include Waterfall

  API_URL = 'https://haveibeenpwned.com/api/v2'

  attr_reader :connection

  def initialize
    @connection = Faraday.new(API_URL) do |conn|
      conn.response :json, content_type: /\bjson$/

      conn.adapter Faraday.default_adapter
    end
  end

  def call
    chain { @response = connection.get('breaches') }
    chain(:breaches) { normalize(@response.body) }
  end

  private

  def normalize(response) # rubocop:disable Metrics/MethodLength
    response.map do |item|
      {
        title: item['Title'],
        domain: item['Domain'],
        breach_date: Date.parse(item['BreachDate']),
        compromised_accounts: item['PwnCount'],
        description: item['Description'],
        compromised_data: item['DataClasses'],
        logo: logo("#{item['Name']}.#{item['LogoType']}"),
        haveibeenpwned: {
          verified: item['IsVerified'],
          fabricated: item['IsFabricated'],
          sensitive: item['IsSensitive'],
          active: item['IsActive'],
          retired: item['IsRetired'],
          spam_list: item['IsSpamList']
        }
      }
    end
  end

  def logo(filename)
    response = Faraday.get("https://haveibeenpwned.com/Content/Images/PwnedLogos/#{filename}")
    {
      mime_type: response.headers['content-type'],
      data: Base64.strict_encode64(response.body)
    }
  end
end
