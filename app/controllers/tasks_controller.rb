class TasksController < ApplicationController
  def create
    render_422(task) and return unless create_task!
    render json: task, status: 201
  end

  def index
    render json: Task.completed and return if params[:state] == 'completed'
    render json: Task.all
  end

  def update
    render_422(task) and return unless update_task!
    render json: task
  end

  def destroy
    task.destroy
    render status: 204
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
    params.permit(:name, :completed_at)
  end

  def task
    @task ||= Task.find(params[:id])
  end
end
