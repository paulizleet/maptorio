class Modpack
  include Mongoid::Document

  belongs_to :modsuite

  field :name, type: String

  has_many :items
  has_many :recipes
end
