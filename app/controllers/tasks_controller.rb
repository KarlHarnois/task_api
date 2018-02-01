class TasksController < ApplicationController
  def create
    @task = Task.create(task_params)
    if @task.save
      render json: @task, status: 201
    else
      render json: errors, status: 422
    end
  end

  def index
    render json: Task.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      render json: @task
    else
      render json: errors, status: 422
    end
  end

  private

  def task_params
    params.permit(:name)
  end

  def errors
    { errors: @task.errors.full_messages }
  end
end
