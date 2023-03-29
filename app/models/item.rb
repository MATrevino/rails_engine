class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  belongs_to :merchant

  validates_presence_of :name, :description, :unit_price, :merchant_id


  def self.search_by_name(name_search)
    where("name ILIKE ?", "%#{name_search}%")
    .order(:name)
    .first
  end

  def self.min_price(query)
    where("unit_price >= ?", query)
    .order(:unit_price)
  end

  def self.max_price(query)
    where("unit_price <= ?", query)
    .order(:unit_price)
  end

  def self.search_min_max_price(min_price, max_price)
    where("unit_price >= ? AND unit_price <= ?", min_price, max_price)
    .order(:unit_price)
  end
end
