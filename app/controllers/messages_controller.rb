class MessagesController < ApplicationController
  def new
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.new
  end

  def create
    @conversation = Conversation.find(params[:conversation_id])
    result = Messages::Creator.call(conversation: @conversation, params: message_params)

    if result.success?
      redirect_to @conversation, notice: "Message was successfully created."
    else
      @message = result.record
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @messages = if params[:q].present?
      Message.search_by_text(params[:q]).includes(:conversation)
    else
      Message.none
    end
  end

  private

  def message_params
    params.require(:message).permit(:text, :date_time_sent)
  end
end
