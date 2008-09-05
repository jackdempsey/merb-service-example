class Gists < Application
  # provides :xml, :yaml, :js

  def index
    @gists = Gist.all
    display @gists
  end

  def show
    @gist = Gist.get(params[:id])
    raise NotFound unless @gist
    display @gist
  end

  def new
    only_provides :html
    @gist = Gist.new
    render
  end

  def edit
    only_provides :html
    @gist = Gist.get(params[:id])
    raise NotFound unless @gist
    render
  end

  def create
    @gist = Gist.new(params[:gist])
    if @gist.save
      redirect url(:gist, @gist)
    else
      render :new
    end
  end

  def update
    @gist = Gist.get(params[:id])
    raise NotFound unless @gist
    if @gist.update_attributes(params[:gist]) || !@gist.dirty?
      redirect url(:gist, @gist)
    else
      raise BadRequest
    end
  end

  def destroy
    @gist = Gist.get(params[:id])
    raise NotFound unless @gist
    if @gist.destroy
      redirect url(:gist)
    else
      raise BadRequest
    end
  end

end # Gists
