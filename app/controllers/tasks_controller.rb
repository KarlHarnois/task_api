class TasksController < ApplicationController
  def create
    @task = Task.create(task_params)
    render_422 and return unless @task.save
    render json: @task, status: 201
  end

  def index
    render json: Task.all
  end

  def update
    @task = Task.find(params[:id])
    render_422 and return unless update_task!
    render json: @task
  end

  private

  def task_params
    params.permit(:name)
  end

  def update_task!
    @task.update_attributes(task_params)
  end

  def render_422
    render json: errors, status: 422
  end

  def errors
    { errors: @task.errors.full_messages }
  end
end
