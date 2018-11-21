class Modsuite
  
  include Mongoid::Document
  #extend FriendlyID

  #friendly_id :name, use: :slugged


  field :name, type: String
  field :description, type: String
  has_many :modpacks

  has_many :items, through: :modpacks
  has_many :recipes, through: :modpacks


end
