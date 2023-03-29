require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  describe 'class methods' do
    it '.search_by_name' do
      merchant_id = create(:merchant).id
      item1 = create(:item, name: "Dog toy", merchant_id: merchant_id)
      item2 = create(:item, name: "Dog bed", merchant_id: merchant_id)
      item3 = create(:item, name: "Cat toy", merchant_id: merchant_id)

      expect(Item.search_by_name("dog")).to eq(item2)
      expect(Item.search_by_name("Dog")).to eq(item2)
      expect(Item.search_by_name("Do")).to eq(item2)

    end
  end
end