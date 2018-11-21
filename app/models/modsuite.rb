class Modsuite
  
  include Mongoid::Document
  #extend FriendlyID

  #friendly_id :name, use: :slugged


  field :name, type: String
  field :description, type: String
  embeds_many :items
  embeds_many :recipes


end
