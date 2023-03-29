class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.search_by_name(name_search)
    where("name ILIKE ?", "%#{name_search}%")
    .order(:name)
  end
end
