require 'rails_helper'

RSpec.describe CommonAncestors, type: :model do
  let(:root) { create(:node) }
  let(:other) { create(:node) }
  let(:parent) { create(:node, parent: root) }
  let(:uncle) { create(:node, parent: root) }
  let(:child) { create(:node, parent: parent) }
  let(:grandchild) { create(:node, parent: child) }
  let(:common_ancestors) { CommonAncestors.new(node_a: node_a, node_b: node_b) }
  let(:node_a) { parent }
  let(:node_b) { grandchild }

  describe "#lowest" do
    let(:node_b) { uncle }
    describe "returns nil if" do
      let(:node_a) { root }
      let(:node_b) { other }
      it "there is no common ancestor" do
        expect(common_ancestors.lowest).to be_nil
      end

      it "there is no other node" do
        node_b = nil
        expect(common_ancestors.lowest).to be_nil
      end
    end

    context 'when it is the same node' do
      let(:node_a) { grandchild }
      let(:node_b) { grandchild }

      it 'returns itself' do
        expect(common_ancestors.lowest).to eq(node_a)
      end
    end

    it "returns the lowest common ancestor of two nodes" do
      expect(common_ancestors.lowest).to eq(root)
    end
  end

  describe "#root_common_ancestor" do
    
    it "returns the root common ancestor of the two nodes" do
      expect(common_ancestors.root).to eq(root)
    end
  end

  describe "#depth_common_ancestors" do
    it "returns the depeth of common ancestor" do
      expect(common_ancestors.depth).to eq(1)
    end

    context "returns nil" do
      let(:node_a) { root }
      let(:node_b) { other }
      it "returns nil when no common ancestors" do
        expect(common_ancestors.depth).to be_nil
      end
    end
  end
end

