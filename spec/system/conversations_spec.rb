require "rails_helper"

RSpec.describe "Conversations", type: :system do
  it "allows creating a conversation" do
    visit conversations_path
    click_link "New Conversation"

    fill_in "Title", with: "Project Kickoff"
    fill_in "Start date", with: Date.current.to_s

    click_button "Create Conversation"

    expect(page).to have_content("Conversation was successfully created")
    expect(page).to have_content("Project Kickoff")
  end

  it "displays validation errors for invalid conversation" do
    visit new_conversation_path

    click_button "Create Conversation"

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Start date can't be blank")
  end

  it "displays all conversations" do
    create(:conversation, title: "Standup Meeting")
    create(:conversation, title: "Sprint Review")

    visit conversations_path

    expect(page).to have_content("Standup Meeting")
    expect(page).to have_content("Sprint Review")
  end

  it "allows searching conversations by title" do
    create(:conversation, title: "Standup Meeting")
    create(:conversation, title: "Sprint Review")

    visit conversations_path
    fill_in "q", with: "standup"
    click_button "Search"

    expect(page).to have_content("Standup Meeting")
    expect(page).not_to have_content("Sprint Review")
  end

  it "shows conversation with messages and thoughts" do
    conversation = create(:conversation, title: "Team Discussion")
    message = create(:message, conversation: conversation, text: "What do you think?")
    create(:thought, message: message, text: "I agree completely")

    visit conversation_path(conversation)

    expect(page).to have_content("Team Discussion")
    expect(page).to have_content("What do you think?")
    expect(page).to have_content("I agree completely")
  end
end
