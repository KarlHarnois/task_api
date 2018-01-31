class TasksController < ApplicationController
  def create
    Task.create(task_params)
  end

  private

  def task_params
    params.permit(:name)
  end
end
