class ThoughtsController < ApplicationController
  def new
    @message = Message.find(params[:message_id])
    @thought = @message.thoughts.new
  end

  def create
    @message = Message.find(params[:message_id])
    result = Thoughts::Creator.call(message: @message, params: thought_params)

    if result.success?
      redirect_to @message.conversation, notice: "Thought was successfully created."
    else
      @thought = result.record
      render :new, status: :unprocessable_entity
    end
  end

  private

  def thought_params
    params.require(:thought).permit(:text, :date_time_sent)
  end
end
