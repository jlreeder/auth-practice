class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    username, password = session_params.values
    @user = User.find_by_credentials(username, password)
    if @user
      login!(@user)
      redirect_to user_url(@user)
    else
      @user = User.new
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end
end

