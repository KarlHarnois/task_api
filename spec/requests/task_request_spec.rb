require 'rails_helper'

describe 'Tasks API', type: :request do
  let(:body) { JSON.parse(response.body) }
  let(:params) { { name: 'SomeName' } }

  let(:headers) do
    { 'Authorization' => "Basic #{Base64.strict_encode64('SomeName:SomePassword')}" }
  end

  let(:not_found_error) do
    { 'error' => { 'message' => "Couldn't find Task with 'id'=1" } }
  end

  let(:missing_name_error) do
    { 'error' => { 'message' => "Name can't be blank" } }
  end

  describe 'POST /tasks' do
    before { post '/tasks', headers: headers, params: params }

    it 'creates a new task' do
      expect(Task.last.name).to eq 'SomeName'
    end

    it 'returns the created task' do
      expect(body).to include('name' => 'SomeName', 'id' => 1)
    end

    it 'returns the correct status code' do
      expect(response).to have_http_status :created
    end

    context 'when task creation fails' do
      let(:params) { { name: nil } }

      it 'returns an error' do
        expect(body).to include missing_name_error
      end

      it 'returns the correct status code' do
        expect(response).to have_http_status 422
      end
    end
  end

  describe 'GET /tasks' do
    let!(:tasks) { create_list :task, 3 }

    before { get '/tasks', headers: headers }

    describe 'response body' do
      it 'contains the correct amount of objects' do
        expect(body.size).to eq 3
      end

      it 'contains tasks' do
        expect(body).to all(include('name', 'id', 'created_at', 'updated_at'))
      end
    end
  end

  describe 'PATCH /tasks/:id' do
    let(:patch_task) { patch '/tasks/1', headers: headers, params: params }

    context 'when the task update succeed' do
      let!(:task) { create :task }

      before { patch_task }

      it 'can update task names' do
        expect(task.reload.name).to eq 'SomeName'
      end

      it 'returns the updated task' do
        expect(body).to include('name' => 'SomeName')
      end

      it 'returns the correct status code' do
        expect(response).to have_http_status 200
      end
    end

    context 'when the task update fails' do
      let!(:task) { create :task }
      let(:params) { { name: nil } }

      before { patch_task }

      it 'returns an error' do
        expect(body).to include missing_name_error
      end

      it 'returns the correct status code' do
        expect(response).to have_http_status 422
      end
    end

    context 'when task does not exist' do
      before { patch_task }

      it 'returns the correct status code' do
        expect(response).to have_http_status 404
      end

      it 'returns the correct error' do
        expect(body).to include not_found_error
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let(:delete_task) { delete '/tasks/1', headers: headers }

    context 'when task exist for id param' do
      let!(:task) { create :task }

      before { delete_task }

      it 'returns the correct status code' do
        expect(response).to have_http_status 204
      end

      it 'delete the correct task' do
        expect { task.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when task does not exist' do
      before { delete_task }

      it 'returns the correct status code' do
        expect(response).to have_http_status 404
      end

      it 'returns the correct error' do
        expect(body).to include not_found_error
      end
    end
  end
end
