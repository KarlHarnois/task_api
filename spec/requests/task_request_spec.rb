require 'rails_helper'

describe 'Tasks API', type: :request do
  let(:body) { JSON.parse(response.body) }

  let(:params) do
    {
      name: 'SomeName',
      completed_at: '19 August 1993'
    }
  end

  let(:headers) do
    { 'Authorization' => "Basic #{Base64.strict_encode64('SomeName:SomePassword')}" }
  end

  let(:missing_name_error) do
    { 'error' => "Name can't be blank" }
  end

  describe 'POST /tasks' do
    before { post '/tasks', headers: headers, params: params }

    it 'creates a new task' do
      expect(Task.last.name).to eq 'SomeName'
    end

    it 'returns the created task' do
      expect(body).to include('name' => 'SomeName', 'id' => Task.last.id)
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

    it 'returns the correct amount of objects' do
      expect(body.size).to eq tasks.count
    end

    it 'returns tasks' do
      expect(body).to all(include('name', 'id', 'created_at', 'updated_at'))
    end
  end

  describe 'GET /tasks?state' do
    let!(:completed_tasks) { create_list :task, 2, completed_at: Time.now }
    let!(:open_task) { create :task }
    let(:received_ids) { body.map { |t| t['id'] } }

    context 'when getting completed tasks' do
      before { get '/tasks?state=completed', headers: headers }

      it 'returns the correct tasks' do
        expect(received_ids).to eq completed_tasks.map(&:id)
      end
    end

    context 'when getting open tasks' do
      before { get '/tasks?state=open', headers: headers }

      it 'returns the correct tasks' do
        expect(received_ids).to eq [open_task.id]
      end
    end
  end

  describe 'PATCH /tasks/:id' do
    let(:patch_task) { patch '/tasks/1', headers: headers, params: params }

    context 'when the task update succeed' do
      let!(:task) { create :task, id: 1 }

      let(:expected_attributes) do
        { name: 'SomeName', completed_at: '1993-08-19'.to_datetime }
      end

      before { patch_task }

      it "can update the task's attributes" do
        expect(task.reload).to have_attributes(expected_attributes)
      end

      it 'returns the updated task' do
        expect(body).to include('name' => 'SomeName')
      end

      it 'returns the correct status code' do
        expect(response).to have_http_status 200
      end
    end

    context 'when the task update fails' do
      let!(:task) { create :task, id: 1 }
      let(:params) { { name: nil } }

      before { patch_task }

      it 'returns an error' do
        expect(body).to include missing_name_error
      end

      it 'returns the correct status code' do
        expect(response).to have_http_status 422
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let(:delete_task) { delete '/tasks/1', headers: headers }

    context 'when task exist for id param' do
      let!(:task) { create :task, id: 1 }

      before { delete_task }

      it 'returns the correct status code' do
        expect(response).to have_http_status 204
      end

      it 'delete the correct task' do
        expect { task.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
