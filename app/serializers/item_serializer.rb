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

  def self.format_item_show(item)
    {
      id: item.id,
      name: item.name,
      unit_price: item.unit_price,
      description: item.description
    }
  end

  def self.format_item_create(item)
    {
      id: item.id,
      name: item.name,
      unit_price: item.unit_price,
      description: item.description
    }
  end
end