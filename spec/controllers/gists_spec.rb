require File.join( File.dirname(__FILE__), '..', "spec_helper" )

# this brings in things like BadRequest
include Merb::ControllerExceptions

describe Gists, ".json" do

  def do_get(id=nil)
    get "/gists/#{id}.json"
  end

  def do_post(params)
    post '/gists/.json', {:gist => params}
  end

  def do_put(id,params)
    put "/gists/#{id}.json", {:gist => params}
  end

  def do_delete(id)
    delete "/gists/#{id}.json"
  end

  it "should respond successfully to a GET of /.json" do
    do_get.should be_successful
  end

  it "should respond successfully to a GET on an existing object" do
    mock(Gist).get('1') { true }
    do_get(1).should be_successful
  end

  it "should respond successfully to a POST with good data" do
    do_post(:url => 'url').should be_successful
  end

  it "should not respond successfully to a POST with bad data" do
    lambda { do_post(:name => 'foo') }.should raise_error(BadRequest)
  end

  it "should not respond successfully to a PUT on a not found record" do
    mock(Gist).get('1') { nil }
    lambda { do_put(1,:name => 'url') }.should raise_error(NotFound)
  end

  it "should respond successfully to a PUT on a found record" do
    mock(gist = Gist.new).update_attributes(anything) { false }
    mock(gist).dirty? { true }
    mock(Gist).get('1') { gist }

    lambda { do_put(1,:url => 'url') }.should raise_error(BadRequest)
  end

  it "should not respond successfully to a PUT with bad data" do
    mock(Gist).get('1') { Gist.new }
    do_put(1,:url => 'url').should be_successful
  end

  it "should respond successfully to a DELETE on a found record" do
    mock(gist = Object.new).destroy { 1 }
    mock(Gist).get('1') { gist }
    lambda { do_delete(1) }.should raise_error(OK)
  end

  it "should not respond successfully to a DELETE that fails" do
    mock(gist = Object.new).destroy { false }
    mock(Gist).get('1') { gist }
    lambda { do_delete(1) }.should raise_error(BadRequest)
  end

  it "should not respond successfully to a DELETE on a not found record" do
    mock(Gist).get('1') { nil }
    lambda { do_delete(1) }.should raise_error(NotFound)
  end

end