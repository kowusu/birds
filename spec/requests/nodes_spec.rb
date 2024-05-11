require 'rails_helper'

RSpec.describe "Nodes", type: :request do
  describe "GET /nodes/:node_a_id/common_ancestors/node_b_id" do
    let(:root) { create(:node) }
    let(:child) { create(:node, parent: root) }
    let(:grandchild) { create(:node, parent: child) }
    let(:unrelated_node) { create(:node) }

    context "when common ancestors exist" do
      context 'returns the lowest common ancestor' do
        before { get "/nodes/#{child.id}/common_ancestors/#{grandchild.id}" }
        specify { expect(response).to have_http_status(:ok) }
        specify { expect(json_response['lowest_common_ancestor']).to eq(root.id) }
        specify { expect(json_response['root_id']).to eq(root.id) }
      end
    end

    context "when no common ancestor is found" do
      context "returns null values" do
        before { get "/nodes/#{grandchild.id}/common_ancestors/#{unrelated_node.id}" }
        specify { expect(response).to have_http_status(:ok) }
        specify { expect(json_response['lowest_common_ancestor']).to be_nil }
      end
    end

    context 'when a node does not exist' do
      context 'returns null values' do
        before { get "/nodes/#{grandchild.id}/common_ancestors/9999" }
        specify { expect(response).to have_http_status(:ok) }
        specify { expect(json_response['lowest_common_ancestor']).to be_nil }
      end
    end
  end
  
  def json_response
    JSON.parse(response.body)
  end
end
