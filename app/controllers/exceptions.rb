class Exceptions < Application
  provides :json

  # handle BadRequest exceptions (400)
  def bad_request
    render ''
  end

  # handle NotFound exceptions (404)
  def not_found
    render ''
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render ''
  end

  def ok
    render ''
  end

end