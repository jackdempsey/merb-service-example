require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Gists, "/index" do

  def do_get
    get '/gists/index.json'
  end
  
  it "should respond successfully to a GET of /index.json" do
    do_get.should be_successful
  end

end