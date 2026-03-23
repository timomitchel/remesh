# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Conversations', type: :request do
  describe 'GET /conversations' do
    it 'returns a successful response' do
      get conversations_path
      expect(response).to have_http_status(:ok)
    end

    it 'displays conversations' do
      create(:conversation, title: 'Team Standup')
      get conversations_path
      expect(response.body).to include('Team Standup')
    end

    context 'with search query' do
      let!(:matching) { create(:conversation, title: 'Team Standup') } # rubocop:disable RSpec/LetSetup
      let!(:non_matching) { create(:conversation, title: 'Budget Review') } # rubocop:disable RSpec/LetSetup

      it 'filters conversations by title' do # rubocop:disable RSpec/MultipleExpectations
        get conversations_path, params: { q: 'standup' }
        expect(response.body).to include('Team Standup')
        expect(response.body).not_to include('Budget Review')
      end
    end

    context 'with empty search query' do
      it 'shows all conversations' do # rubocop:disable RSpec/MultipleExpectations
        create(:conversation, title: 'Alpha')
        create(:conversation, title: 'Beta')
        get conversations_path, params: { q: '' }
        expect(response.body).to include('Alpha')
        expect(response.body).to include('Beta')
      end
    end
  end

  describe 'GET /conversations/:id' do
    let(:conversation) { create(:conversation) }

    it 'returns a successful response' do
      get conversation_path(conversation)
      expect(response).to have_http_status(:ok)
    end

    it 'displays messages and thoughts' do # rubocop:disable RSpec/MultipleExpectations
      message = create(:message, conversation: conversation, text: 'Hello world')
      create(:thought, message: message, text: 'Interesting point')

      get conversation_path(conversation)
      expect(response.body).to include('Hello world')
      expect(response.body).to include('Interesting point')
    end
  end

  describe 'GET /conversations/new' do
    it 'returns a successful response' do
      get new_conversation_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /conversations' do
    context 'with valid params' do
      let(:valid_params) { { conversation: { title: 'New Discussion', start_date: Date.current } } }

      it 'creates a conversation' do
        expect do
          post conversations_path, params: valid_params
        end.to change(Conversation, :count).by(1)
      end

      it 'redirects to the conversation' do
        post conversations_path, params: valid_params
        expect(response).to redirect_to(Conversation.last)
      end

      it 'sets a flash notice' do
        post conversations_path, params: valid_params
        follow_redirect!
        expect(response.body).to include('Conversation was successfully created')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { conversation: { title: '', start_date: nil } } }

      it 'does not create a conversation' do
        expect do
          post conversations_path, params: invalid_params
        end.not_to change(Conversation, :count)
      end

      it 'returns unprocessable entity' do
        post conversations_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'displays validation errors' do
        post conversations_path, params: invalid_params
        expect(response.body).to include('Title can&#39;t be blank')
      end
    end
  end
end
