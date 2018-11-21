class Item
    
    include Mongoid::Document

    field :name, type: String
    field :icon, type: String
    field :subgroup, type: String
    
    belongs_to :modpack

end
