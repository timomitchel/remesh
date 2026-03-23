# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:conversation) { create(:conversation) }

  describe 'GET /conversations/:conversation_id/messages/new' do
    it 'returns a successful response' do
      get new_conversation_message_path(conversation)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /conversations/:conversation_id/messages' do
    context 'with valid params' do
      let(:valid_params) { { message: { text: 'Hello world', date_time_sent: Time.current } } }

      it 'creates a message' do
        expect do
          post conversation_messages_path(conversation), params: valid_params
        end.to change(Message, :count).by(1)
      end

      it 'redirects to the conversation' do
        post conversation_messages_path(conversation), params: valid_params
        expect(response).to redirect_to(conversation)
      end

      it 'sets a flash notice' do
        post conversation_messages_path(conversation), params: valid_params
        follow_redirect!
        expect(response.body).to include('Message was successfully created')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { message: { text: '', date_time_sent: nil } } }

      it 'does not create a message' do
        expect do
          post conversation_messages_path(conversation), params: invalid_params
        end.not_to change(Message, :count)
      end

      it 'returns unprocessable entity' do
        post conversation_messages_path(conversation), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /messages/search' do
    it 'returns a successful response' do
      get search_messages_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns no results without a query' do
      create(:message, conversation: conversation, text: 'Something')
      get search_messages_path
      expect(response.body).not_to include('Something')
    end

    it 'searches messages by text' do
      create(:message, conversation: conversation, text: 'Important discussion')
      get search_messages_path, params: { q: 'important' }
      expect(response.body).to include('Important discussion')
    end

    it 'shows parent conversation context' do
      conv = create(:conversation, title: 'Project Alpha')
      create(:message, conversation: conv, text: 'Status update')
      get search_messages_path, params: { q: 'status' }
      expect(response.body).to include('Project Alpha')
    end

    it 'excludes non-matching messages' do # rubocop:disable RSpec/MultipleExpectations
      create(:message, conversation: conversation, text: 'Relevant content')
      create(:message, conversation: conversation, text: 'Unrelated stuff')
      get search_messages_path, params: { q: 'relevant' }
      expect(response.body).to include('Relevant content')
      expect(response.body).not_to include('Unrelated stuff')
    end
  end
end
