require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Gists, "/" do

  def do_get
    get '/gists.json'
  end

  def do_post(params)
    post '/gists.json', {:gist => params}
  end

  it "should respond successfully to a GET of /index.json" do
    do_get.should be_successful
  end

  it "should respond successfully to a POST with good data" do
    controller = do_post :url => 'foo'
    controller.should be_successful
  end

end