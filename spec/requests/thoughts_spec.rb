require "rails_helper"

RSpec.describe "Thoughts", type: :request do
  let(:conversation) { create(:conversation) }
  let(:message) { create(:message, conversation: conversation) }

  describe "GET /messages/:message_id/thoughts/new" do
    it "returns a successful response" do
      get new_message_thought_path(message)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /messages/:message_id/thoughts" do
    context "with valid params" do
      let(:valid_params) { {thought: {text: "Great point!", date_time_sent: Time.current}} }

      it "creates a thought" do
        expect {
          post message_thoughts_path(message), params: valid_params
        }.to change(Thought, :count).by(1)
      end

      it "redirects to the conversation" do
        post message_thoughts_path(message), params: valid_params
        expect(response).to redirect_to(conversation)
      end

      it "sets a flash notice" do
        post message_thoughts_path(message), params: valid_params
        follow_redirect!
        expect(response.body).to include("Thought was successfully created")
      end
    end

    context "with invalid params" do
      let(:invalid_params) { {thought: {text: "", date_time_sent: nil}} }

      it "does not create a thought" do
        expect {
          post message_thoughts_path(message), params: invalid_params
        }.not_to change(Thought, :count)
      end

      it "returns unprocessable entity" do
        post message_thoughts_path(message), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
