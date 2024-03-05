# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_round, only: %i[new create index]
  before_action :set_task, only: %i[show edit update destroy start estimate]

  def index
    @rounds = @round.tasks
  end

  def show; end

  def new
    @task = @round.tasks.new
  end

  def edit; end

  def create
    @task = @round.tasks.new(task_params)

    if @task.save
      message = 'Task was successfully created.'
      respond_to do |format|
        format.html { redirect_to round_path(@task.round), notice: message }
        format.turbo_stream { flash.now[:notice] = message }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      message = 'Task was successfully updated.'
      respond_to do |format|
        format.html { redirect_to round_path(@task.round), notice: message }
        format.turbo_stream { flash.now[:notice] = message }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    message = 'Task was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to round_path(@task.round), notice: message }
      format.turbo_stream { flash.now[:notice] = message }
    end
  end

  def start
    Tasks::Start.new(task: @task, round: @round).call

    respond_to do |format|
      format.html { redirect_to round_path(@task.round) }
      format.turbo_stream { nil }
    end
  end

  def estimate
    @current_estimation = Tasks::Estimate.new(user: current_user, task: @task).call(params[:value].to_i)

    respond_to do |format|
      format.html { redirect_to round_path(@task.round) }
      format.turbo_stream { nil }
    end
  end

  private

  def set_round
    @round = Round.find(params[:round_id])
  end

  def set_task
    @task = Task.find(params[:id])
    @round = @task.round
  end

  def task_params
    params.require(:task).permit(:title)
  end
end
