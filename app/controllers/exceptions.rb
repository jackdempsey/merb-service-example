class Exceptions < Merb::Controller
  
  # handle NotFound exceptions (404)
  def not_found
    # look into use params[:format] if you want to display html and json
    render :format => :json
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    # look into use params[:format] if you want to display html and json
    render :format => :json
  end

end