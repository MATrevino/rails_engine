class ItemSerializer
  def self.format_items(items)
    items.map do |item|
      {
        id: item.id,
        name: item.name,
        unit_price: item.unit_price,
        description: item.description
      }
    end
  end
end