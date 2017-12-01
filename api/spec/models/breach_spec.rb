# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Breach, type: :model do
  subject(:breach) { described_class.all.first }
  let(:breach_sample) { JSON.parse(File.read(file_fixture('breach.sample.json'))) }

  before(:all) do
    described_class.create(JSON.parse(File.read(file_fixture('breach.sample.json'))))
    described_class.refresh_index!
  end

  after(:all) do
    described_class.all.each(&:delete)
    described_class.refresh_index!
  end

  it 'searches for the breach' do
    breach_sample['breach_date'] = Date.parse(breach_sample['breach_date'])

    expect(described_class.search('linkedin').first.as_json.deep_stringify_keys)
      .to match(hash_including(breach_sample))
  end

  it 'builds data uri' do
    expect(breach.data_uri).to eq "data:image/svg+xml,base64;#{breach.logo['data']}"
  end

  context 'when multiple breaches with the same data' do
    before do
      3.times { described_class.create(breach_sample) }
      described_class.refresh_index!
    end

    after do
      described_class.search('linkedin').each do |breach|
        next if breach.slug == 'linkedin'
        breach.delete
      end
      described_class.refresh_index!
    end

    it 'creates unique slugs' do
      breaches = described_class.search('linkedin').sort_by(&:slug)

      expect(breaches.map(&:slug)).to eq(%w[linkedin linkedin-1 linkedin-2 linkedin-3])
    end
  end
end
