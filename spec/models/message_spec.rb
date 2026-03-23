# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to have_many(:thoughts).order(date_time_sent: :asc).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_presence_of(:date_time_sent) }
  end

  describe 'dependent destroy' do
    it 'destroys associated thoughts when message is destroyed' do
      message = create(:message, :with_thoughts)
      expect { message.destroy }.to change(Thought, :count).by(-3)
    end
  end

  describe '.search_by_text' do
    let(:conversation) { create(:conversation) }
    let!(:matching) { create(:message, conversation: conversation, text: 'Great idea about the project') }
    let!(:non_matching) { create(:message, conversation: conversation, text: "Let's schedule a meeting") }

    it 'returns messages matching the query (case-insensitive)' do # rubocop:disable RSpec/MultipleExpectations
      results = described_class.search_by_text('idea')
      expect(results).to include(matching)
      expect(results).not_to include(non_matching)
    end

    it 'returns partial matches' do
      expect(described_class.search_by_text('great')).to include(matching)
    end

    it 'returns none for blank query' do # rubocop:disable RSpec/MultipleExpectations
      expect(described_class.search_by_text('')).to be_empty
      expect(described_class.search_by_text(nil)).to be_empty
    end

    it 'sanitizes % in search input' do
      special = create(:message, conversation: conversation, text: 'Success rate: 95%')
      expect(described_class.search_by_text('95%')).to include(special)
    end

    it 'sanitizes _ in search input' do
      special = create(:message, conversation: conversation, text: 'use snake_case here')
      expect(described_class.search_by_text('snake_c')).to include(special)
    end
  end
end
