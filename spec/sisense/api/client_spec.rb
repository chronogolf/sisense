RSpec.describe Sisense::API::Client do
  SUPPORTED_HTTP_VERBS = %i[get post put delete].freeze

  context 'constants' do
    describe 'VERB_MAP' do
      it('is defined') { expect(described_class.const_defined?('VERB_MAP')).to eq true }
      it { expect(described_class::VERB_MAP.keys).to match_array(SUPPORTED_HTTP_VERBS) }
    end
  end

  describe '#initialize' do
    it 'defines http client instance' do
      expect(subject.http).to be_a Net::HTTP
    end
  end

  shared_examples 'a request made over http' do
    let(:stubbed_request) { stub_request(method_used, "http://test-sisense.chronogolf.ca:80#{endpoint}") }

    before do
      stubbed_request
      request
    end

    it { expect(stubbed_request).to have_been_requested }
  end

  context 'requests' do
    let(:endpoint) { '/test-endpoint' }

    SUPPORTED_HTTP_VERBS.each do |method|
      describe "using `#{method.upcase}` method" do
        it_behaves_like 'a request made over http' do
          let(:method_used) { method }
          let(:request) { subject.send(method_used, endpoint) }
        end
      end
    end
  end

  describe '#parsed_response' do
    context 'when response is single object' do
      around { |test| VCR.use_cassette('user_retrieve') { test.run } }

      let(:response) { subject.get('/api/v1/users/5b3293ad1ed43bccb04e2029') }
      let(:object_class) { Sisense::User }
      let(:parsed_response) { subject.parsed_response(response, object_class: object_class) }

      it { expect(parsed_response).to be_a(object_class) }
    end

    context 'when response is collection' do
      around { |test| VCR.use_cassette('users_list') { test.run } }

      let(:response_collection) { subject.get('/api/v1/users') }
      let(:object_class) { Sisense::User }
      let(:parsed_response) { subject.parsed_response(response_collection, object_class: object_class) }

      it { expect(parsed_response).to be_a(Array) }

      it 'converts all response items as the expect object' do
        expect(parsed_response.all? { |item| item.is_a?(object_class) }).to eq true
      end
    end
  end
end
