class Application < Merb::Controller
  def errors_for(obj)
    obj.errors.full_messages.join("; ")
  end
end