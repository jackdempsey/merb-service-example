class Gist
  include DataMapper::Resource
  include DataMapper::Serialize

  property :id, Integer, :serial => true
  property :name, String
  property :updated_at, DateTime
  property :url, String
  property :created_at, DateTime

end
