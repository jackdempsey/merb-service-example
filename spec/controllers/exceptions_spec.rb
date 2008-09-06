require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Exceptions do

  it "should respond successfully to bad_request" do
    dispatch_to(Exceptions, :bad_request, {:format => :json}).should be_successful
  end

  it "should respond successfully to not_found" do
    dispatch_to(Exceptions, :not_found, {:format => :json}).should be_successful
  end

  it "should respond successfully to not_acceptable" do
    dispatch_to(Exceptions, :not_acceptable, {:format => :json}).should be_successful
  end

  it "should respond successfully to ok" do
    dispatch_to(Exceptions, :ok, {:format => :json}).should be_successful
  end

end