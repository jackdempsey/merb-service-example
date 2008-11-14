class Exceptions < Merb::Controller
  provides :json
  
  # handle NotFound exceptions (404)
  def not_found
    return standard_error if content_type == :json
    render
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    return standard_error if content_type == :json
    render
  end

  def standard_error
    # Re-Raise so we get the pretty merb error document instead.
    raise request.exceptions.first if content_type == :html

    @exceptions = request.exceptions
    @show_details = Merb::Config[:exception_details]
    render :standard_error
  end

end