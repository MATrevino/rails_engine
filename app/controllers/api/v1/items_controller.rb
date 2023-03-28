class Api::V1::ItemsController < ApplicationController
  def index
    # items = Item.all
    # render json: ItemSerializer.format_items(items)
    render json: ItemSerializer.new(Item.all)
  end

  def show
    # item = Item.find(params[:id])
    # render json: ItemSerializer.format_item_show(item)
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    Item.create(item_params)
    # render json: ItemSerializer.format_item_create(Item.last)
    render json: ItemSerializer.new(Item.last)
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    # render json: ItemSerializer.format_item_create(item)
    render json: ItemSerializer.new(item)
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    render json: ItemSerializer.format_item_create(item)
 
  end

  private
  
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end