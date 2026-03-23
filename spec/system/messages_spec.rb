# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  let(:conversation) { create(:conversation, title: 'Team Discussion') }

  def set_flatpickr_date(element_id, value)
    page.execute_script(
      "document.getElementById('#{element_id}')._flatpickr.setDate('#{value}', true)"
    )
  end

  it 'allows creating a message for a conversation' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit conversation_path(conversation)
    click_link 'Add Message'

    fill_in 'Text', with: 'This is my message'
    find('.flatpickr-alt-btn', wait: 5)
    set_flatpickr_date('message_date_time_sent', Time.current.strftime('%Y-%m-%dT%H:%M'))

    click_button 'Create Message'

    expect(page).to have_content('Message was successfully created')
    expect(page).to have_content('This is my message')
  end

  it 'disables submit button until all fields are filled' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit conversation_path(conversation)
    click_link 'Add Message'

    find('.flatpickr-alt-btn', wait: 5)
    submit_button = find_button('Create Message')

    expect(submit_button[:style]).to include('rgb(156, 163, 175)')

    fill_in 'Text', with: 'This is my message'
    expect(submit_button[:style]).to include('rgb(156, 163, 175)')

    set_flatpickr_date('message_date_time_sent', Time.current.strftime('%Y-%m-%dT%H:%M'))

    expect(submit_button[:style]).to include('rgb(22, 163, 74)')
  end

  it 'allows searching messages by content' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    create(:message, conversation: conversation, text: 'Important update about the project')
    other_conv = create(:conversation, title: 'Other')
    create(:message, conversation: other_conv, text: 'Unrelated discussion')

    visit search_messages_path
    fill_in 'q', with: 'important'
    click_button 'Search'

    expect(page).to have_content('Important update about the project')
    expect(page).not_to have_content('Unrelated discussion')
    expect(page).to have_content('Team Discussion')
  end

  it 'shows empty state when no search query' do
    visit search_messages_path
    expect(page).to have_content('Enter a search term to find messages')
  end
end
