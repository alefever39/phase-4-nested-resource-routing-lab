class ItemsController < ApplicationController
  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      if user
        items = user.items
        render json: items, except: %i[created_at updated_at]
      else
        render json: { error: "User not found" }, status: :not_found
      end
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: item, except: %i[created_at updated_at]
    else
      render json: { error: "Item not found" }, status: :not_found
    end
  end

  def create
    user = User.find_by(id: params[:user_id])
    if user
      new_item = Item.create(item_params)
      user.items << new_item
      render json: new_item, except: %i[created_at updated_at], status: :created
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end
end
