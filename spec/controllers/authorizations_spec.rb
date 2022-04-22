RSpec.describe Controllers::Authorizations do

  def app
    Controllers::Authorizations.new
  end

  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:session) { create(:session, account: account) }

  describe 'POST /' do
    describe 'Nominal case' do
      before do
        post '/', {
          session_id: session.token,
          application_id: application.id.to_s
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          code: Core::Models::OAuth::Authorization.first.code
        )
      end
    end
    describe 'when the session ID is not given' do
      before do
        post '/', {application_id: application.id.to_s}
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'session_id', error: 'required'
        )
      end
    end
    describe 'when the session ID is not found' do
      before do
        post '/', {
          application_id: application.id.to_s,
          session_id: 'unknown'
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'session_id', error: 'unknown'
        )
      end
    end
    describe 'when the application ID is not given' do
      before do
        post '/', {
          session_id: session.token
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'application_id', error: 'required'
        )
      end
    end
    describe 'when the application ID is not found' do
      before do
        post '/', {
          application_id: 'unknown',
          session_id: session.token
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'application_id', error: 'unknown'
        )
      end
    end
  end
end