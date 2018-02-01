class TasksController < ApplicationController
  def create
    @task = Task.create(task_params)
    render json: @task, status: 201 and return if @task.save
    render json: errors, status: 422
  end

  def index
    render json: Task.all
  end

  def update
    @task = Task.find(params[:id])
    render json: @task and return if update_task!
    render json: errors, status: 422
  end

  private

  def task_params
    params.permit(:name)
  end

  def errors
    { errors: @task.errors.full_messages }
  end

  def update_task!
    @task.update_attributes(task_params)
  end
end
