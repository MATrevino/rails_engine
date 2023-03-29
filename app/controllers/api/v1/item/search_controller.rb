class Api::V1::Item::SearchController < ApplicationController

  def show
    if (params[:name] && (params[:min_price] || params[:max_price]))
      render json: { data: "Can't search for name and price" }, status: 400
    elsif params[:name]
      name_search
    else params[:min_price] || params[:max_price] || (params[:min_price] && params[:max_price])
      price_search
    end
  end

  def name_search
    if Item.search_by_name(params[:name]).nil?
      render json: { data: "Couldn't find Item" }, status: 404
    else
      render json: ItemSerializer.new(Item.search_by_name(params[:name]))
    end
  end

  def price_search
    if (params[:min_price].to_f < 0) || (params[:max_price].to_f < 0)
      render json: { data: "price cannot be negative" }, status: 404
    elsif Item.min_price(params[:min_price]).empty? && Item.max_price(params[:max_price]).empty?
      render json: { data: "Couldn't find Item" }, status: 404
    elsif Item.min_price(params[:min_price]).empty?
      render json: ItemSerializer.new(Item.max_price(params[:max_price]))
    elsif Item.max_price(params[:max_price]).empty?
      render json: ItemSerializer.new(Item.min_price(params[:min_price]))
    else params[:min_price] && params[:max_price]
      render json: ItemSerializer.new(Item.search_min_max_price(params[:min_price], params[:max_price]))
    end
  end
end