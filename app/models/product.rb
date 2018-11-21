class Product
    include Mongoid::Document

    embedded_in :recipe

    has_one :item

    field :quantity, type: Integer
end
