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
