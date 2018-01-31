require 'rails_helper'

describe Task, type: :model do
  describe '#save' do
    context 'when name is nil' do
      before do
        subject.name = nil
      end

      it 'does not save the task' do
        expect(subject.save).to be false
      end
    end

    context 'when named' do
      before { subject.name = 'someName' }

      it 'saves the task' do
        expect(subject.save).to be true
      end
    end
  end
end
