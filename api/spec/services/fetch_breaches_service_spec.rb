# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::FetchBreachesService, type: :service do
  subject(:service) { described_class.new.call }

  context 'when success' do
    let(:dropbox_image) { SecureRandom.uuid }
    let(:dropbox_content_type) { Faker::File.mime_type }
    let(:linkedin_image) { SecureRandom.uuid }
    let(:linkedin_content_type) { Faker::File.mime_type }

    before do
      stub_request(:get, 'https://haveibeenpwned.com/api/v2/breaches')
        .to_return(
          status: :success, body: file_fixture('breaches.json'),
          headers: { 'content-type' => 'application/json; charset=utf-8' }
        )
      stub_request(:get, 'https://haveibeenpwned.com/Content/Images/PwnedLogos/Dropbox.svg')
        .to_return(
          status: :success, body: dropbox_image, headers: { 'content-type' => dropbox_content_type }
        )
      stub_request(:get, 'https://haveibeenpwned.com/Content/Images/PwnedLogos/LinkedIn.svg')
        .to_return(
          status: :success, body: linkedin_image, headers: { 'content-type' => linkedin_content_type }
        )
    end

    it 'succeeds' do
      expect(service.dammed?).to be false
    end

    it 'provides breaches' do
      expect(service.outflow.breaches).to eq(
        [
          {
            title: 'Dropbox',
            domain: 'dropbox.com',
            breach_date: Date.new(2012, 7, 1),
            compromised_accounts: 68_648_009,
            description: 'In mid-2012, Dropbox suffered a data breach which exposed the stored credentials of tens ' \
                         'of millions of their customers. In August 2016, <a href="https://motherboard.vice.com/read/' \
                         'dropbox-forces-password-resets-after-user-credentials-exposed" target="_blank" ' \
                         'rel="noopener">they forced password resets for customers they believed may be at risk</a>. ' \
                         'A large volume of data totalling over 68 million records ' \
                         '<a href="https://motherboard.vice.com/read/hackers-stole-over-60-million-dropbox-accounts" ' \
                         'target="_blank" rel="noopener">was subsequently traded online</a> and included email ' \
                         'addresses and salted hashes of passwords (half of them SHA1, half of them bcrypt).',
            compromised_data: [
              'Email addresses',
              'Passwords'
            ],
            logo: {
              mime_type: dropbox_content_type,
              data: Base64.strict_encode64(dropbox_image)
            },
            haveibeenpwned: {
              verified: true,
              fabricated: false,
              sensitive: false,
              active: true,
              retired: false,
              spam_list: false
            }
          },
          {
            title: 'LinkedIn',
            domain: 'linkedin.com',
            breach_date: Date.new(2012, 5, 5),
            compromised_accounts: 164_611_595,
            description: 'In May 2016, <a href="https://www.troyhunt.com/observations-and-thoughts-on-the-linkedin-' \
                         'data-breach" target="_blank" rel="noopener">LinkedIn had 164 million email addresses and ' \
                         'passwords exposed</a>. Originally hacked in 2012, the data remained out of sight until ' \
                         'being offered for sale on a dark market site 4 years later. The passwords in the breach ' \
                         'were stored as SHA1 hashes without salt, the vast majority of which were quickly cracked ' \
                         'in the days following the release of the data.',
            compromised_data: [
              'Email addresses',
              'Passwords'
            ],
            logo: {
              mime_type: linkedin_content_type,
              data: Base64.strict_encode64(linkedin_image)
            },
            haveibeenpwned: {
              verified: true,
              fabricated: false,
              sensitive: false,
              active: true,
              retired: false,
              spam_list: false
            }
          }
        ]
      )
    end
  end
end
