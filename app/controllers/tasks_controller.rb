class TasksController < ApplicationController
  def create
    task = Task.create(task_params)
    render json: task, status: 201
  end

  def index
    render json: Task.all
  end

  def update
    task = Task.find(params[:id])
    if task.update_attributes(task_params)
      render json: task
    else
      render json: { errors: task.errors.full_messages }, status: 422
    end
  end

  private

  def task_params
    params.permit(:name)
  end
end
