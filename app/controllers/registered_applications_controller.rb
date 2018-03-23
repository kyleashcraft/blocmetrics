class RegisteredApplicationsController < ApplicationController
  def show
    @app = RegisteredApplication.find(params[:id])
    authorize(current_user, @app)
    @events = @app.events.group_by(&:name)
  end

  def index
    authorize_user
    @apps = RegisteredApplication.where(user: current_user)
  end

  def new
    authorize_user
    @app = RegisteredApplication.new
  end

  def create
    authorize_user
    @app = RegisteredApplication.new(app_params)
    @app.user = current_user

    if @app.save
      flash[:notice] = "Application was registered"
      redirect_to @app
    else
      flash.now[:alert] = "There was an error registering your application. Please try again."
      render :new
    end
  end

  def destroy
    @app = RegisteredApplication.find(params[:id])

    authorize(current_user, @app)

    if @app.destroy
      flash[:notice] = "Registration successfully removed."
      redirect_to registered_applications_path
    else
      flash.now[:alert] = "Error removing application registration, please try again."
    end
  end

  private

    def app_params
      params.require(:registered_application).permit(:name, :url, :user)
    end

    def authorize_user
      unless current_user
        flash[:alert] = "You must be logged in to do that."
        redirect_to root_path
      end
    end

    def authorize(current_user, app)
      unless current_user.id == app.user_id
        flash[:alert] = "You are not allowed to do that."
        redirect_to root_path
      end
    end
end
