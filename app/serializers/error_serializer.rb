class ErrorSerializer
  def initialize(error_item)
    @error_item = error_item
  end

  def serialized_json
    {
      errors: [
        {
          status: @error_object.status,
          messsage: "Invalid",
          code: @error_object.code
        }
      ]
    }
  end
end