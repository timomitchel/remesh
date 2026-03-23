# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Thoughts', type: :system do
  let(:conversation) { create(:conversation, title: 'Team Discussion') }
  let!(:message) { create(:message, conversation: conversation, text: 'What do you think?') }

  it 'allows creating a thought for a message' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit conversation_path(conversation)

    within("#message-#{message.id}") do
      click_link 'Add Thought'
    end

    fill_in 'Text', with: 'I think this is great'
    find('.flatpickr-alt-btn', wait: 5)
    page.execute_script("document.getElementById('thought_date_time_sent')._flatpickr.setDate('#{Time.current.strftime('%Y-%m-%dT%H:%M')}', true)")

    click_button 'Create Thought'

    expect(page).to have_content('Thought was successfully created')
    expect(page).to have_content('I think this is great')
  end

  it 'disables submit button until all fields are filled' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit conversation_path(conversation)

    within("#message-#{message.id}") do
      click_link 'Add Thought'
    end

    find('.flatpickr-alt-btn', wait: 5)
    submit_button = find_button('Create Thought')

    expect(submit_button[:style]).to include('rgb(156, 163, 175)')

    fill_in 'Text', with: 'I think this is great'
    expect(submit_button[:style]).to include('rgb(156, 163, 175)')

    page.execute_script("document.getElementById('thought_date_time_sent')._flatpickr.setDate('#{Time.current.strftime('%Y-%m-%dT%H:%M')}', true)")

    expect(submit_button[:style]).to include('rgb(22, 163, 74)')
  end
end
