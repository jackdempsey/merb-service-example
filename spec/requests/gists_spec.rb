require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/gists.json" do

  before do
    @request = request("/gists.json")
  end
  
  it "should return successfully" do
    @request.should be_successful
  end
  
  it "should return json" do
    @request.should have_content_type(:json)
  end
  
end