require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "#index" do
  it "should return successfully" do
    request("/gists.json").should be_successful
  end

  it "should return json" do
    request("/gists.json").should have_content_type(:json)
  end
end    

describe "#show" do
  # it "should display an item when found" do
  #   gist = Gist.create(:url => 'www.example.com')
  #   request("/gists/#{gist.id}.json").should be_successful
  # end
  # figure out why the spec below doesn't work when we comment out the one above
  it "should raise a NotFound when item is not found" do
    #request("/gists/bad_id.json").should raise_not_found
    request("/gists/bad_id.json").status.should == 404
  end
end