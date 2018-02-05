require 'rails_helper'

describe Task, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:task)).to be_valid
  end

  describe '#save' do
    context 'when task name is nil' do
      before { subject.name = nil }

      it 'does not save the task' do
        expect(subject.save).to be false
      end
    end

    context 'when task is named' do
      before { subject.name = 'someName' }

      it 'saves the task' do
        expect(subject.save).to be true
      end
    end
  end
end
