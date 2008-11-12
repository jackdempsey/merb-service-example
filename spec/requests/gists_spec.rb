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

describe "#create" do
  describe "successful" do
    before do
      #curl -H "Content-Type:application/json" -d "{\"gist\":{\"url\":\"test.com\"}}" http://localhost:4000/gists.json
      @request = request("/gists.json", :params => {:gist => {:url => 'www.example.com'}},
                                        :method => "POST") # we can't use :post; look in the code, it checks for "POST"
    end

    it "should render successfully" do
      @request.should be_successful
    end

    it "should return a 201 status" do
      @request.status.should == 201
    end

    it "should have content type json" do
      @request.should have_content_type(:json)
    end
  end

  describe "unsuccessful" do
    before do
      @request = request("/gists.json", :params => {:gist => {:url => ''}},
                                        :method => "POST")
    end

    it "should return a BadRequest" do
      @request.should be_client_error
    end

    it "should display the errors on the gist" do
      @request.body.to_s.should =~ /Url must not be blank/
    end
  end

end