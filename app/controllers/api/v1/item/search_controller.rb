class Api::V1::Item::SearchController < ApplicationController

  def show
    @item = Item.search_by_name(params[:name])
    if @item.nil?
      render json: { errors: "Couldn't find Item" }
    else
      render json: ItemSerializer.new(@item)
    end
  end
end