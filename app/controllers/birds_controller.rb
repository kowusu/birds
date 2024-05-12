class BirdsController < ApplicationController

  def index
    node_ids = params[:node_ids].map(&:to_i)
    all_related_node_ids = Node.find_node_ids_with_descendant_ids(node_ids)
    bird_ids = Bird.where(node_id: all_related_node_ids).pluck(:id)
    render json: { bird_ids: bird_ids }
  end
end
