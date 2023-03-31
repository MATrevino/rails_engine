class ErrorSerializer
  def initialize(error)
    @error = error
  end

  def serialized_json
    {
      errors: [
        {
          status: @error.status,
          title: @error.message
        }
      ]
    }
  end
end