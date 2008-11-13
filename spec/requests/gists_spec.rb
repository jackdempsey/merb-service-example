require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

include Merb::ControllerExceptions

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
      @response = request("/gists/#{gist.id}.json")
    end

    it "should return json" do
      @response.should have_content_type(:json)
    end

    it "should display an item when found" do
      @response.should be_successful
    end
  end

  describe "unsuccessful" do
    before do
      @response = request("/gists/0.json")
    end

    it "should return a NotFound if missing" do
      @response.should be_missing
    end

    it "should return json" do
      @response.should have_content_type(:json)
    end
  end
end

describe "#create" do
  describe "successful" do
    before do
      #curl -H "Content-Type:application/json" -d "{\"gist\":{\"url\":\"test.com\"}}" http://localhost:4000/gists.json
      @response = request("/gists.json", :params => {:gist => {:url => 'www.example.com'}},
                                        :method => "POST") # we can't use :post; look in the code, it checks for "POST"
    end

    it "should render successfully" do
      @response.should be_successful
    end

    it "should return a 201 status" do
      @response.status.should == Created.status
    end

    it "should have content type json" do
      @response.should have_content_type(:json)
    end
  end

  describe "unsuccessful" do
    before do
      @response = request("/gists.json", :params => {:gist => {:url => ''}},
                                        :method => "POST")
    end

    it "should return a BadRequest" do
      @response.should be_client_error
    end

    it "should display the errors on the gist" do
      @response.body.to_s.should include("Url must not be blank")
    end
  end
end

describe "#update" do
  describe "successful" do
    before do
      # create object to update
      result = request("/gists.json", :params => {:gist => {:url => 'www.example.com'}},
                                        :method => 'POST')
      result_body = JSON.parse(result.body.to_s)

      # send the update
      @new_url = "#{result_body['url']}#{Time.now.to_i}"
      @response = request("/gists/#{result_body['id']}.json", :params => {:gist => {:url => @new_url}},
                                                           :method => 'PUT')
      @body = JSON.parse(@response.body.to_s)
    end

    it "should return an Accepted status" do
      @response.status.should == Accepted.status
    end

    it "should display the gist with updated attributes" do
      @body['url'].should == @new_url
    end

    it "should have content type json" do
      @response.should have_content_type(:json)
    end
  end

  describe "unsuccessful" do
    before do
      # create object to update
      result = request("/gists.json", :params => {:gist => {:url => 'www.example.com'}},
                                      :method => 'POST')
      result_body = JSON.parse(result.body.to_s)

      # send the bad update
      @response = request("/gists/#{result_body['id']}.json", :params => {:gist => {:url => ''}},
                                                              :method => 'PUT')
      @body = JSON.parse(@response.body.to_s)
    end

    it "should return a NotFound if missing" do
      pending
    end

    it "should return a BadRequest" do
      @response.should be_client_error
    end

    it "should display the errors" do
      # look at standard_error.json.erb for a layout of whats displayed. That structure is why we're looking at @body['exceptions'] here
      # and grabbing the list of exceptions to search in
      @body['exceptions'].map {|exception| exception['message']}.should include("Url must not be blank")
    end
  end
end

describe "#destroy" do
  describe "successful" do
    before do
      # create a gist to destroy
      result = request("/gists.json", :params => {:gist => {:url => 'www.example.com'}},
                                      :method => 'POST')
      result_body = JSON.parse(result.body.to_s)

      # send the delete
      @response = request("/gists/#{result_body['id']}.json", :method => 'DELETE')
    end

    it "should render a status OK" do
      @response.status.should == NoContent.status # a successful DELETE returns a 204 and no body
    end

    it "should return an empty body" do
      @response.should have_body('')
    end
  end

  describe "unsuccessful" do
    it "should return a NotFound if missing" do
      pending
    end

    it "should return a BadRequest" do
      pending
    end

    it "should display the errors" do
      pending
    end
  end
end
