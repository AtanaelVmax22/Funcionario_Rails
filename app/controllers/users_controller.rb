class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users.map { |user| user_attributes(user) }
  end

  # GET /users/1
  def show
    render json: user_attributes(@user)
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: user_attributes(@user), status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: user_attributes(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :document, :role)
  end

  def user_attributes(user)
    user.attributes.merge({ 'role_description' => user.role_description })
  end
end
