require "rails_helper"

RSpec.describe "Thoughts", type: :system do
  let(:conversation) { create(:conversation, title: "Team Discussion") }
  let!(:message) { create(:message, conversation: conversation, text: "What do you think?") }

  it "allows creating a thought for a message" do
    visit conversation_path(conversation)

    within("#message-#{message.id}") do
      click_link "Add Thought"
    end

    fill_in "Text", with: "I think this is great"
    fill_in "Date/time sent", with: Time.current.strftime("%Y-%m-%dT%H:%M")

    click_button "Create Thought"

    expect(page).to have_content("Thought was successfully created")
    expect(page).to have_content("I think this is great")
  end
end
