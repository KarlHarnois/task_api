require 'rails_helper'

describe 'Tasks API', type: :request do
  describe 'POST #create' do
    before do
      post '/tasks', params: { name: 'SomeName' }
    end

    it 'creates a new task' do
      expect(Task.last.name).to eq 'SomeName'
    end
  end
end
