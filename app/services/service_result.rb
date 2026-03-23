# frozen_string_literal: true

# Value object encapsulating the outcome of a service operation.
# Provides a consistent success/failure contract with access to
# the persisted record and any validation errors.
class ServiceResult
  attr_reader :record, :errors

  def initialize(success:, record: nil, errors: nil)
    @success = success
    @record = record
    @errors = errors
  end

  def success?
    @success
  end

  def failure?
    !success?
  end
end
