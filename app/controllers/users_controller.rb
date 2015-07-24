class UsersController < ApplicationController 
  before_action :user_signed_in?, only: [:edit, :update, :choose, :destroy]

  def show
    @user = User.find(params[:id])
  end 

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save 
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to login_path
    else 
      render 'new'
    end 
  end 

  def destroy
    @user = User.find(params[:id])
    if (@user == current_user)
      flash[:danger] = "You cannot delete your own account!"
      redirect_to admin_users_path
    else
      @user.destroy
      @users = User.all
      flash[:success] = "User deleted."
      redirect_to admin_users_path
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to join_or_create_path
    else
      render 'edit'
    end
  end

  private 
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end 

end