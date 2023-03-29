class Api::V1::Item::SearchController < ApplicationController

  def show
    @item = Item.search_by_name(params[:name])
    # @item = Item.search_by_price(params[:min_price]) if @item.nil?
    if @item.nil?
      render json: { errors: "Couldn't find Item" }
    else
      render json: ItemSerializer.new(@item)
    end
  end

  # def name_search

  # end

  # def price_search
  # end
end