class Exceptions < Application
  provides :json

  # handle BadRequest exceptions (400)
  def bad_request
    render_nil
  end

  # handle NotFound exceptions (404)
  def not_found
    render_nil
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render_nil
  end

  # handle OK exceptions (200)
  def ok
    render_nil
  end

  private

  # need a clean way to render nothing and return a status
  # for now we use this little wrapper method.
  def render_nil
    render ''
  end
end