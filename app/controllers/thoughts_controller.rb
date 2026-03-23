# frozen_string_literal: true

# Handles creation of Thought resources nested under messages.
class ThoughtsController < ApplicationController
  def new
    @message = Message.find(params[:message_id])
    @thought = @message.thoughts.new
  end

  def create
    @message = Message.find(params[:message_id])
    result = Thoughts::Creator.call(message: @message, params: thought_params)

    if result.success?
      redirect_to @message.conversation, notice: 'Thought was successfully created.' # rubocop:disable Rails/I18nLocaleTexts
    else
      @thought = result.record
      render :new, status: :unprocessable_content
    end
  end

  private

  def thought_params
    params.expect(thought: %i[text date_time_sent])
  end
end
