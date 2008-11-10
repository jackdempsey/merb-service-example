class Gist
  include DataMapper::Resource
  include DataMapper::Serialize

  validates_present :url
  
  property :id, Integer, :serial => true
  property :name, String
  property :url, String
  property :updated_at, DateTime
  property :created_at, DateTime

end
