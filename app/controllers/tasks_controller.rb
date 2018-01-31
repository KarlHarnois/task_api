class TasksController < ApplicationController
  def create
    Task.create(name: params[:name])
  end
end
