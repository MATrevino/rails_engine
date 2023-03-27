class MerchantSerializer
  def self.format_merchant(merchants)
    merchants.map do |merchant|
      {
        id: merchant.id,
        name: merchant.name
      }
    end
  end

  def self.format_merchant_show(merchant)
    {
      id: merchant.id,
      name: merchant.name
    }
  end

  def self.format_merchant_items(merchant)
    merchant.items.map do |item|
      {
        id: item.id,
        name: item.name,
        description: item.description,
        unit_price: item.unit_price
      }
    end
  end
end