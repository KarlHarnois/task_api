require 'rails_helper'

describe 'Tasks API', type: :request do
  let(:body) { JSON.parse(response.body) }
  let(:params) { { name: 'SomeName' } }

  describe 'POST #create' do
    before { post '/tasks', params: params }

    it 'creates a new task' do
      expect(Task.last.name).to eq 'SomeName'
    end

    it 'returns the created task' do
      expect(body).to include('name' => 'SomeName', 'id' => 1)
    end

    it 'returns the correct status code' do
      expect(response).to have_http_status(:created)
    end
  end

  describe 'GET #index' do
    let!(:tasks) { create_list :task, 3 }

    before { get '/tasks' }

    describe 'response body' do
      it 'contains the correct amount of objects' do
        expect(body.size).to eq 3
      end

      it 'contains tasks' do
        expect(body).to all(include('name', 'id', 'created_at', 'updated_at'))
      end
    end
  end

  describe 'PATCH #update' do
    let!(:task) { create :task }

    before { patch '/tasks/1', params: params }

    it 'can update task names' do
      expect(task.reload.name).to eq 'SomeName'
    end

    it 'returns the updated task' do
      expect(body).to include('name' => 'SomeName')
    end

    it 'returns the correct status code' do
      expect(response).to have_http_status(200)
    end

    context 'when the task update fails' do
      let(:params) { { name: nil } }

      it 'returns an error' do
        expect(body).to include('errors' => ["Name can't be blank"])
      end

      it 'returns the correct status code' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
