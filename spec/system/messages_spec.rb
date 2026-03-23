require "rails_helper"

RSpec.describe "Messages", type: :system do
  let(:conversation) { create(:conversation, title: "Team Discussion") }

  it "allows creating a message for a conversation" do
    visit conversation_path(conversation)
    click_link "Add Message"

    fill_in "Text", with: "This is my message"
    fill_in "Date/time sent", with: Time.current.strftime("%Y-%m-%dT%H:%M")

    click_button "Create Message"

    expect(page).to have_content("Message was successfully created")
    expect(page).to have_content("This is my message")
  end

  it "allows searching messages by content" do
    create(:message, conversation: conversation, text: "Important update about the project")
    other_conv = create(:conversation, title: "Other")
    create(:message, conversation: other_conv, text: "Unrelated discussion")

    visit search_messages_path
    fill_in "q", with: "important"
    click_button "Search"

    expect(page).to have_content("Important update about the project")
    expect(page).not_to have_content("Unrelated discussion")
    expect(page).to have_content("Team Discussion")
  end

  it "shows empty state when no search query" do
    visit search_messages_path
    expect(page).to have_content("Enter a search term to find messages")
  end
end
