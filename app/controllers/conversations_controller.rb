# frozen_string_literal: true

# Handles CRUD operations for Conversation resources.
class ConversationsController < ApplicationController
  def index
    @conversations = if params[:q].present?
                       Conversation.search_by_title(params[:q])
                     else
                       Conversation.all
                     end
    @conversations = @conversations.order(start_date: :desc)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages
                             .includes(:thoughts)
                             .order(date_time_sent: :asc)
  end

  def new
    @conversation = Conversation.new
  end

  def create
    result = Conversations::Creator.call(params: conversation_params)

    if result.success?
      redirect_to result.record, notice: 'Conversation was successfully created.' # rubocop:disable Rails/I18nLocaleTexts
    else
      @conversation = result.record
      render :new, status: :unprocessable_content
    end
  end

  private

  def conversation_params
    params.expect(conversation: %i[title start_date])
  end
end
