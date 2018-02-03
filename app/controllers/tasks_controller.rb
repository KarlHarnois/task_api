class TasksController < ApplicationController
  def create
    render_422 and return unless create_task!
    render json: task, status: 201
  end

  def index
    render json: Task.all
  end

  def update
    render_422 and return unless update_task!
    render json: task
  end

  private

  def create_task!
    @task = Task.create(task_params)
    @task.save
  end

  def update_task!
    task.update_attributes(task_params)
  end

  def task_params
    params.permit(:name)
  end

  def task
    @task ||= Task.find(params[:id])
  end

  def render_422
    render json: errors, status: 422
  end

  def errors
    { errors: @task.errors.full_messages }
  end
end
