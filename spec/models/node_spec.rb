require 'rails_helper'

RSpec.describe Node, type: :model do
  let(:root) { create(:node) }
  let(:other) { create(:node) }
  let(:parent) { create(:node, parent: root) }
  let(:uncle) { create(:node, parent: root) }
  let(:child) { create(:node, parent: parent) }

  describe "#ancestors" do
    it "returns an empty array if the node has no parents" do
      expect(root.ancestors).to eq([])
    end

    it "returns all ancestors of a node" do
      expect(child.ancestors).to eq([parent, root])
    end
  end

  describe "#lowest_common_ancestor" do
    describe "returns nil if" do
      it "there is no common ancestor" do
        expect(root.lowest_common_ancestor(other)).to be_nil
      end

      it "there is no other node" do
        expect(root.lowest_common_ancestor(nil)).to be_nil
      end
    end

    it "returns the lowest common ancestor of two nodes" do
      expect(uncle.lowest_common_ancestor(child)).to eq(root)
    end
  end
end
