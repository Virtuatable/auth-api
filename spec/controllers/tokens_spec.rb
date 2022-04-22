RSpec.describe Controllers::Tokens do

  def app
    Controllers::Tokens.new
  end

  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:authorization) {
    create(:authorization, application: application, account: account)
  }

  describe 'POST /' do
    describe 'Nominal case' do
      before do
        post '/', {
          authorization_code: authorization.code,
          application_id: application.id.to_s
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          token: Core::Models::OAuth::AccessToken.first.value
        })
      end
    end
    describe 'When the authorization code is not given' do
      before do
        post '/', {
          application_id: application.id.to_s
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'authorization_code', error: 'required'
        )
      end
    end
    describe 'When the authorization code is not found' do
      before do
        post '/', {
          application_id: application.id.to_s,
          authorization_code: 'unknown'
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'authorization_code', error: 'unknown'
        )
      end
    end
    describe 'When the application ID is not given' do
      before do
        post '/', {
          authorization_code: authorization.code
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
    describe 'When the application ID is not found' do
      before do
        post '/', {
          application_id: 'unknown',
          authorization_code: authorization.code
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'application_id', error: 'unknown'
        )
      end
    end
    describe 'when the authorization code belongs to another app' do
      let!(:second_app) {
        create(:application, name: 'Another brilliant app', creator: account)
      }
      before do
        post '/', {
          application_id: second_app.id.to_s,
          authorization_code: authorization.code
      }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'application_id', error: 'mismatch'
        )
      end
    end
  end
end