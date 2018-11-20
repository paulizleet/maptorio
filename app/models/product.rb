class Product
    include Mongoid::Document

    belongs_to :recipe

    has_one :item

    field :quantity, type: Integer
end
