class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def profile
    render json: { user: UserSerializer.new(current_user) }, status: :accepted
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      Game.create(new_ranking: @user.ranking, user_id: @user.id)
      @token = encode_token(user_id: @user.id)
      render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
    else
      render json: { error: 'failed to create user' }, status: :not_acceptable
    end
  end

  def show
    @user = User.find(params[:id])
    @games = @user.games
    render json: @games
  end

  private
  def user_params
    params.permit(:username, :password, :password_confirmation, :ranking)
  end




  def user_games_params

  end




end
