FactoryBot.define do
  factory :task do
    name 'Create Task Management API'

    factory :completed_task do
      completed_at Time.now
    end

    factory :open_task do
      completed_at nil
    end
  end
end
