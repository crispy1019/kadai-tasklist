class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def index
    @tasks = Task.all
    # if current_user.id != @task.user_id
    #   redirect_to  '/'
    # end
  end

  def show
    if current_user.id != @task.user_id
      redirect_to  '/'
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Task が投稿されませんでした'
      render 'toppages/index'
    end
  end

  def edit
    if current_user.id != @task.user_id
      redirect_to  '/'
    end
  end

  def update
    if current_user.id != @task.user_id
      redirect_to  '/'
    end
    
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    if current_user.id != @task.user_id
      redirect_to  '/'
    end
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    # redirect_to tasks_url
    redirect_back(fallback_location: root_path)
  end
  
  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content,:status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end