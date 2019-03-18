RSpec.describe Sisense::API::Client do
  SUPPORTED_HTTP_VERBS = %i[get post put patch delete].freeze

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
    let(:stubbed_request) { stub_request(method_used, "http://test-sisense.chronogolf.ca#{endpoint}") }

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

  describe 'errors' do
    context 'when get 404' do
      around { |test| VCR.use_cassette('user_retrieve_404') { test.run } }

      it 'raises' do
        expect { subject.get('/api/v1/users/5b3293ad1ed43bccb04e2029') }.to raise_error Sisense::API::NotFoundError
      end
    end

    context 'when get 422' do
      around { |test| VCR.use_cassette('user_retrieve_422') { test.run } }

      it 'raises' do
        expect { subject.get('/api/v1/users/5b3293ad1ed43bccb04e2029') }.to raise_error Sisense::API::UnprocessableEntityError
      end
    end

    context 'when get other error' do
      around { |test| VCR.use_cassette('user_retrieve_500') { test.run } }

      it 'raises' do
        expect { subject.get('/api/v1/users/5b3293ad1ed43bccb04e2029') }.to raise_error Sisense::API::Error
      end
    end

    context 'with error details in body in legacy format' do
      around { |test| VCR.use_cassette('user_retrieve_500_v0_9') { test.run } }

      it 'collects body errors' do
        subject.get('/api/v1/users/5b3293ad1ed43bccb04e2029')
      rescue Sisense::API::Error => e
        expect(e).to have_attributes(code: 'X123', status: 'error', message: 'any server error')
      end
    end

    context 'with error details in body' do
      around { |test| VCR.use_cassette('user_retrieve_500') { test.run } }

      it 'collects body errors' do
        subject.get('/api/v1/users/5b3293ad1ed43bccb04e2029')
      rescue Sisense::API::Error => e
        expect(e).to have_attributes(code: 'X123', status: 'error', message: 'any server error')
      end
    end
  end
end
