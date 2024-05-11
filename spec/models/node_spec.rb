require 'rails_helper'

RSpec.describe Node, type: :model do
  let(:root) { create(:node) }
  let(:other) { create(:node) }
  let(:parent) { create(:node, parent: root) }
  let(:uncle) { create(:node, parent: root) }
  let(:child) { create(:node, parent: parent) }
  let(:grandchild) { create(:node, parent: child) }

  describe "#family_tree" do
    it "returns an empty array if the node has no parents" do
      expect(root.family_tree).to eq([])
    end

    it "returns all ancestors of a node" do
      expect(child.family_tree).to eq([root, parent])
    end
  end
end
