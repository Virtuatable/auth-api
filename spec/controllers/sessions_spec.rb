RSpec::describe Controllers::Sessions do
  def app
    Controllers::Sessions.new
  end

  describe 'POST /sessions' do
    it 'blah' do
      post '/sessions'
      expect(last_response.status).to be 201
    end
  end
end