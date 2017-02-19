class UsersController < ApplicationController
  before_action :ensure_logged_in, only: [:edit, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Invalid params: either username in use or password below 6 chars"]
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
      flash[:errors] = ["You can only edit your own page"]
      redirect_to user_url(current_user)
    end
  end

  def update
    @user = User.new(user_params)
    if @user && @user.update
      redirect_to user_url(@user)
    else
      render text: "Failure: invalid params"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
