require "rails_helper"

RSpec.describe ServiceResult do
  describe "success" do
    let(:record) { build(:conversation) }
    let(:result) { ServiceResult.new(success: true, record: record) }

    it "is successful" do
      expect(result).to be_success
    end

    it "is not a failure" do
      expect(result).not_to be_failure
    end

    it "returns the record" do
      expect(result.record).to eq(record)
    end

    it "has nil errors" do
      expect(result.errors).to be_nil
    end
  end

  describe "failure" do
    let(:record) { build(:conversation) }
    let(:errors) { double("errors") }
    let(:result) { ServiceResult.new(success: false, record: record, errors: errors) }

    it "is not successful" do
      expect(result).not_to be_success
    end

    it "is a failure" do
      expect(result).to be_failure
    end

    it "returns errors" do
      expect(result.errors).to eq(errors)
    end
  end
end
