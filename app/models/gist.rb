class Gist
  include DataMapper::Resource

  property :name, String
  property :updated_at, DateTime
  property :url, String
  property :created_at, DateTime

end
