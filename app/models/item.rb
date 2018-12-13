class Item
    
    include Mongoid::Document

    field :name, type: String
    field :local_name, type: String
    field :icon, type: String
    field :subgroup, type: String
    
    embedded_in :ingredient
    embedded_in :product
    embedded_in :modsuite

    #validates :name, presence: true
    

end
