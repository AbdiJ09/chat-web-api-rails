class Api::MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @user = User.find_by(id: params[:user_id])
    if @user.nil?
      render json: { message: "User not found" }, status: :not_found
      return
    end

    @message = @chatroom.messages.new(message_params.merge(user: @user))
    if @message.save
      Pusher.trigger("chatroom-#{@chatroom.id}", "new-message", {
        id: @message.id,
        user_id: @message.user_id,
        user: @message.user,
        chatroom_id: @message.chatroom_id,
        content: @message.content,
        created_at: @message.created_at
      })
      render json: @message, include: :user, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def index
    chatroom = Chatroom.find(params[:chatroom_id])
    @messages = chatroom.messages.order(created_at: :asc)
    render json: @messages, include: :user
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
