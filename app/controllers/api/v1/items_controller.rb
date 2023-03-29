class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    begin
     render json: ItemSerializer.new(Item.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => e
     render json: ErrorSerializer.new(e).serialized_json, status: 404
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
     render json: ItemSerializer.new(item), status: 201
    else
    #  render json: ErrorSerializer.new(item).serialized_json, status: 404
      render json: { errors: "Invalid Update" }, status: 404
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    
    if item.save
      render json: ItemSerializer.new(item)
    else
    #  render json: ErrorSerializer.new(item).serialized_json, status: 404
      render json: { errors: "Invalid Update" }, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    render json: ItemSerializer.new(item)
    #get ride of the ItemSerializer, not needed
  end

  def search
    @item = Item.find_by(name: params[:name])
    if @item
      render json: @item
    else
      render json: { error: "Couldn't find Item" }, status: :not_found
    end
  end

  private
  
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end