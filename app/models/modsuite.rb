class Modsuite
  
  include Mongoid::Document
  #extend FriendlyID

  #friendly_id :name, use: :slugged


  field :name, type: String
  field :description, type: String
  field :graph, type: String #JSON string of the map to send

  embeds_many :items
  embeds_many :recipes


end
