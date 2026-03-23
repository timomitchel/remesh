# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Conversations', type: :system do
  it 'allows creating a conversation' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit conversations_path
    click_link 'New Conversation'

    fill_in 'Title', with: 'Project Kickoff'
    find('.flatpickr-alt-btn', wait: 5)
    page.execute_script("document.getElementById('conversation_start_date')._flatpickr.setDate('#{Date.current}', true)")

    click_button 'Create Conversation'

    expect(page).to have_content('Conversation was successfully created')
    expect(page).to have_content('Project Kickoff')
  end

  it 'disables submit button until all fields are filled' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit new_conversation_path

    find('.flatpickr-alt-btn', wait: 5)
    submit_button = find_button('Create Conversation')

    expect(submit_button[:style]).to include('rgb(156, 163, 175)')

    fill_in 'Title', with: 'Project Kickoff'
    expect(submit_button[:style]).to include('rgb(156, 163, 175)')

    page.execute_script("document.getElementById('conversation_start_date')._flatpickr.setDate('#{Date.current}', true)")

    expect(submit_button[:style]).to include('rgb(22, 163, 74)')
  end

  it 'displays validation errors for invalid conversation' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit new_conversation_path

    find('.flatpickr-alt-btn', wait: 5)
    page.execute_script("document.querySelector('form').submit()")

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Start date can't be blank")
  end

  it 'displays all conversations' do # rubocop:disable RSpec/MultipleExpectations
    create(:conversation, title: 'Standup Meeting')
    create(:conversation, title: 'Sprint Review')

    visit conversations_path

    expect(page).to have_content('Standup Meeting')
    expect(page).to have_content('Sprint Review')
  end

  it 'allows searching conversations by title' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    create(:conversation, title: 'Standup Meeting')
    create(:conversation, title: 'Sprint Review')

    visit conversations_path
    fill_in 'q', with: 'standup'
    click_button 'Search'

    expect(page).to have_content('Standup Meeting')
    expect(page).not_to have_content('Sprint Review')
  end

  it 'shows conversation with messages and thoughts' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    conversation = create(:conversation, title: 'Team Discussion')
    message = create(:message, conversation: conversation, text: 'What do you think?')
    create(:thought, message: message, text: 'I agree completely')

    visit conversation_path(conversation)

    expect(page).to have_content('Team Discussion')
    expect(page).to have_content('What do you think?')
    expect(page).to have_content('I agree completely')
  end
end
