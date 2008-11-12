class Exceptions < Merb::Controller
  provides :json
  
  # handle NotFound exceptions (404)
  def not_found
    # look into use params[:format] if you want to display html and json
    return standard_error if content_type == :json
    render :format => :json
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    # look into use params[:format] if you want to display html and json
    return standard_error if content_type == :json
    render :format => :json
  end

  def standard_error
    # Re-Raise so we get the pretty merb error document instead.
    raise request.exceptions.first if content_type == :html

    @exceptions = request.exceptions
    @show_details = Merb::Config[:exception_details]
    render :standard_error
  end

end