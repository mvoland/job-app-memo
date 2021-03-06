class JobInformationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_my_profile

  def new
    @user = User.find(params[:user_id])
    @job_application = @user.job_applications.find(params[:job_application_id])
    @new_job_information = @job_application.job_informations.new
    respond_to do |format|
      format.html { render 'job_applications/show' }
      format.js {}
    end
  end

  def create
    @user = User.find(params[:user_id])
    @job_application = @user.job_applications.find(params[:job_application_id])
    @new_job_information = @job_application.job_informations.new(job_information_params)

    respond_to do |format|
      if @new_job_information.save
        format.html do
          flash[:success] = 'Nouvelle information ajoutée'
          redirect_to user_job_application_path(@user, @job_application)
        end
        format.js
      else
        format.html { render 'job_applications/show' }
        format.js { render 'job_informations/new' }
      end
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @job_application = @user.job_applications.find(params[:job_application_id])
    @edit_job_information = @job_application.job_informations.find(params[:id])
    respond_to do |format|
      format.html { render 'job_applications/show' }
      format.js {}
    end
  end

  def update
    @user = User.find(params[:user_id])
    @job_application = @user.job_applications.find(params[:job_application_id])
    @edit_job_information = @job_application.job_informations.find(params[:id])

    respond_to do |format|
      if params[:cancel]
        format.html do
          redirect_to user_job_application_path(@user, @job_application)
        end
        format.js
      elsif @edit_job_information.update(job_information_params)
        format.html do
          flash[:success] = 'Information modifiée'
          redirect_to user_job_application_path(@user, @job_application)
        end
        format.js
      else
        format.html { render 'job_applications/show' }
        format.js { render 'job_informations/edit' }
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @job_application = @user.job_applications.find(params[:job_application_id])
    @destroy_job_information = @job_application.job_informations.find(params[:id])

    respond_to do |format|
      if @destroy_job_information.destroy
        format.html do
          flash[:success] = 'Information supprimée'
          redirect_to user_job_application_path(@user, @job_application)
        end
        format.js
      else
        format.html { render 'job_applications/show' }
      end
    end
  end

  private

  def is_my_profile
    unless current_user == User.find(params[:user_id])
      flash[:danger] = 'Vous ne pouvez pas accéder aux informations de ce compte'
      redirect_to :root
    end
  end

  def job_information_params
    permitted = params.require(:job_information).permit(:name, :content)
  end
end
