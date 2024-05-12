require 'rails_helper'

RSpec.describe "Birds", type: :request do
  describe "GET #index" do
    let!(:root) { create(:node_with_bird) }
    let!(:child) { create(:node_with_bird, parent: root) }
    let(:unrelated) { create(:node) }
    let(:bird) { root.birds.first }
    let(:child_bird) { child.birds.first }

    context "returns bird IDs for given node and its descendants" do
      
      before do 
        allow(Node).to receive(:find_node_ids_with_descendant_ids).and_return([root.id, child.id])
        get '/birds', params: { node_ids: [root.id] } 
      end
      specify { expect(response).to have_http_status(:ok) }
      specify { expect(json_response['bird_ids']).to match_array([bird.id, child_bird.id]) }
    end

    context "handles request with no nodes correctly" do
      before do
        allow(Node).to receive(:find_node_ids_with_descendant_ids).and_return([])
        get '/birds', params: { node_ids: [] }
      end
      specify { expect(response).to have_http_status(:ok) }
      specify { expect(json_response['bird_ids']).to be_empty }
    end

    context "returns an empty array when no birds are found" do
      before do
        allow(Node).to receive(:find_node_ids_with_descendant_ids).and_return([unrelated.id])
        get '/birds', params: { node_ids: [unrelated.id] }
      end
      specify { expect(response).to have_http_status(:ok) }
      specify { expect(json_response['bird_ids']).to be_empty } 
    end
  end
end
