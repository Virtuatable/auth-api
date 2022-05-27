# frozen_string_literal: true

RSpec.describe Controllers::Authentication do
  def app
    Controllers::Authentication.new
  end

  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }

  describe 'GET /sessions/:session_id' do
    describe 'Nominal case' do
      let!(:session) { create(:session, account: account) }

      before do
        get "/sessions/#{session.token}"
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          token: session.token
        )
      end
    end

    describe 'Session UUID not found' do
      before do
        get '/sessions/unknown-session'
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
  end

  describe 'POST /sessions' do
    describe 'Nominal case' do
      before do
        post '/sessions', {
          username: account.username,
          password: 'password'
        }
      end

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          token: Core::Models::Authentication::Session.first.token
        )
      end
    end

    describe 'when the username is not given' do
      before do
        post '/sessions', {
          password: 'password'
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'username',
          error: 'required'
        )
      end
    end

    describe 'when the password is not given' do
      before do
        post '/sessions', {
          username: account.username
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'password',
          error: 'required'
        )
      end
    end

    describe 'when the username is not found' do
      before do
        post '/sessions', { username: 'unknown', password: 'password' }
      end

      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'username', error: 'unknown'
        )
      end
    end

    describe 'when the password is not correct' do
      before do
        post '/sessions', { username: account.username, password: 'wrong_password' }
      end

      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'password', error: 'wrong'
        )
      end
    end
  end
end
