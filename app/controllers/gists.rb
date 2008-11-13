class Gists < Application
  provides :json

  def index
    @gists = Gist.all
    display @gists
  end

  def show
    @gist = Gist.get(params[:id])
    raise NotFound unless @gist
    display @gist
  end

  def create
    @gist = Gist.new(params[:gist])
    if @gist.save
      display @gist, :status => Created
    else
      raise BadRequest, errors_for(@gist)
    end
  end

  def update
    @gist = Gist.get(params[:id])
    raise NotFound unless @gist
    if @gist.update_attributes(params[:gist]) || !@gist.dirty?
      display @gist, :status => Accepted
    else
      raise BadRequest, errors_for(@gist)
    end
  end

  def destroy
    @gist = Gist.get(params[:id])
    raise NotFound unless @gist
    if @gist.destroy
      render '', :status => 204 # possibly extract into something like render_successful_delete?
    else
      raise BadRequest, errors_for(@gist)
    end
  end

end # Gists
