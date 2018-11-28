class Product
    include Mongoid::Document
    field :quantity, type: Integer
    field :name, type: String

    embedded_in :recipe




end
