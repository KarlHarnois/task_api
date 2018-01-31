class TasksController < ApplicationController
  def create
    task = Task.create(task_params)
    render json: task, status: 201
  end

  private

  def task_params
    params.permit(:name)
  end
end
