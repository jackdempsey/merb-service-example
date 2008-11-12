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
  describe "successful" do
    before do
      gist = Gist.create(:url => 'www.example.com')
      @request = request("/gists/#{gist.id}.json")
    end

    it "should return json" do
      @request.should have_content_type(:json)
    end

    it "should display an item when found" do
      @request.should be_successful
    end
  end

  describe "unsuccessful" do
    before do
      @request = request("/gists/0.json")
    end

    it "should return a 404 when an item is not found" do
      @request.should be_missing
    end

    it "should return json" do
      @request.should have_content_type(:json)
    end
  end
end
