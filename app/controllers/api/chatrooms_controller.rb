class Api::ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.all
    render json: @chatrooms, include: { users: { only: [ :name, :id ] } }
  end


  def show
    @chatroom = Chatroom.find_by(id: params[:id])
    render json: @chatroom, include: { messages: { include: :user } }
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    if @chatroom.save
      render json: @chatroom, status: :created
    else
      render json: @chatroom.errors, status: :unprocessable_entity
    end
  end

  def join
    @chatroom = Chatroom.find_by(id: params[:id])
    @user = User.find_by(id: params[:user_id])
    if @chatroom.users << @user
      render json: @chatroom, status: :ok
    else
      render json: @chatroom.errors, status: :unprocessable_entity
    end
  end

  def join_status
    chatroom = Chatroom.find_by(id: params[:id])
    if chatroom.nil?
      render json: { message: "Chatroom not found" }, status: :not_found
      return
    end
    user_id = params[:user_id]
    joined = chatroom.users.exists?(id: user_id)
    render json: { joined: joined }, status: :ok
  end

  def leave_chatroom
    chatroom = Chatroom.find_by(id: params[:id])
    user = User.find_by(id: params[:user_id])

    if chatroom.nil?
      render json: { message: "Chatroom not found" }, status: :not_found
      return
    end

    if user.nil?
      render json: { message: "User not found" }, status: :not_found
      return
    end

    unless chatroom.users.include?(user)
      render json: { message: "User is not in the chatroom" }, status: :bad_request
      return
    end

    if chatroom.users.delete(user)
      render json: { message: "User left the chatroom" }, status: :ok
    else
      render json: { message: "Failed to remove user from chatroom" }, status: :unprocessable_entity
    end
  end
  def chatroom_params
    params.require(:chatroom).permit(:name)
  end
end
