class Gist
  include DataMapper::Resource

  property :id, Integer, :serial => true
  property :name, String
  property :updated_at, DateTime
  property :url, String
  property :created_at, DateTime

  def to_json
    attributes.to_json
  end
end
