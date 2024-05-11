class NodesController < ApplicationController
  def common_ancestors
    common_ancestors = load_common_ancestors
    
    render json: {
      root_id: common_ancestors.root&.id,
      lowest_common_ancestor: common_ancestors.lowest&.id,
      depth: common_ancestors.depth
    }
  end

  private
  
  def load_common_ancestors
    if params[:node_a_id] == params[:node_b_id]
      node_a = node_b = Node.find(params[:node_a_id])
    else
      node_a, node_b = Node.where(id: [params[:node_a_id], params[:node_b_id]]).to_a
    end
    CommonAncestors.new(node_a: node_a, node_b: node_b)
  end
end
