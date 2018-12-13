class ExpensiveIngredient
  include Mongoid::Document

  field :quantity, type: Integer
  field :name, type: String
  field :local_name, type: String
  embedded_in :recipe
  
end
