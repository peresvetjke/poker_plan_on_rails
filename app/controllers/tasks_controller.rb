class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy start]

  def index
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def start
    @task.start!

    redirect_to @task.round
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
