require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

# bring in the constants so we can use NotFound, etc, instead of Merb::ControllerExceptions::NotFound
include Merb::ControllerExceptions

def it_should_return(content_type)
  it "should have content type #{content_type}" do
    @response.should have_content_type(content_type)
  end
end

def it_should_respond_with(status_code)
  it "should render a #{status_code} (#{status_code.status})" do
    @response.status.should == status_code.status
  end
end

describe "#index" do
  before do
    @response = request("/gists.json")
  end

  it_should_respond_with OK

  it_should_return :json
end

describe "#show" do
  describe "successful" do
    before do
      gist = Gist.create(:url => 'www.example.com')
      @response = request("/gists/#{gist.id}.json")
    end

    it_should_respond_with OK

    it_should_return :json
  end

  describe "unsuccessful" do
    before do
      @response = request("/gists/0.json")
    end

    it_should_respond_with NotFound

    it_should_return :json
  end
end

describe "#create" do
  describe "successful" do
    before do
      #curl -H "Content-Type:application/json" -d "{\"gist\":{\"url\":\"test.com\"}}" http://localhost:4000/gists.json
      @response = request("/gists.json", :params => {:gist => {:url => 'www.example.com'}},
                                         :method => "POST") # we can't use :post; look in the code, it checks for "POST"
    end

    it_should_respond_with Created

    it_should_return :json
  end

  describe "unsuccessful" do
    before do
      @response = request("/gists.json", :params => {:gist => {:url => ''}},
                                         :method => "POST")
    end

    it "should display the errors on the gist" do
      @response.body.to_s.should include("Url must not be blank")
    end

    it_should_respond_with BadRequest

    it_should_return :json
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

    it "should display the gist with updated attributes" do
      @body['url'].should == @new_url
    end

    it_should_respond_with Accepted

    it_should_return :json
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

    it "should return a NotFound (404) if missing" do
      request("/gists/0.json", :params => {:gist => {:url => ''}},:method => 'PUT').should be_missing
    end

    it "should display the errors" do
      # look at standard_error.json.erb for a layout of whats displayed. That structure is why we're looking at @body['exceptions'] here
      # and grabbing the list of exceptions to search in
      @body['exceptions'].map {|exception| exception['message']}.should include("Url must not be blank")
    end

    it_should_respond_with BadRequest

    it_should_return :json
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

    it "should return an empty body" do
      @response.should have_body('')
    end

    it_should_respond_with NoContent

    it_should_return :json
  end

  describe "unsuccessful" do
    before do
      # send the delete for a missing id
      @response = request("/gists/0.json", :method => 'DELETE')
    end

    it "should display the NotFound (404) errors" do
      body = JSON.parse(@response.body.to_s)
      body['exceptions'].map {|exception| exception['message']}.should include("Merb::ControllerExceptions::NotFound")
    end

    it_should_respond_with NotFound

    it_should_return :json
  end
end
