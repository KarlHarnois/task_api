require 'rails_helper'

describe 'Tasks API', type: :request do
  describe 'POST #create' do
    let(:body) { JSON.parse(response.body) }

    before do
      post '/tasks', params: { name: 'SomeName' }
    end

    it 'creates a new task' do
      expect(Task.last.name).to eq 'SomeName'
    end

    it 'returns the created task' do
      expect(body).to include('name' => 'SomeName', 'id' => 1)
    end

    it 'has the correct status' do
      expect(response).to have_http_status(:created)
    end
  end
end
