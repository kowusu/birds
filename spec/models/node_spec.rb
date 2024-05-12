require 'rails_helper'

RSpec.describe Node, type: :model do
  let(:root) { create(:node) }
  let(:other) { create(:node) }
  let(:parent) { create(:node, parent: root) }
  let(:uncle) { create(:node, parent: root) }
  let(:child) { create(:node, parent: parent) }
  let(:grandchild) { create(:node, parent: child) }

  describe "#ancestors" do
    it "returns an empty array if the node has no parents" do
      expect(root.ancestors).to eq([])
    end

    it "returns all ancestors of a node" do
      expect(child.ancestors).to eq([root, parent])
    end
  end

  describe "#find_node_ids_with_descendant_ids" do
    it "returns descendant ids for given node ids" do
      [root, parent, child]
      expect(Node.find_node_ids_with_descendant_ids([root.id])).to contain_exactly(root.id,parent.id, child.id)
    end
  end
end
