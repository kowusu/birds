require 'rails_helper'

RSpec.describe Node, type: :model do
  describe "#ancestors" do
    let(:root) { create(:node) }
    let(:parent) { create(:node, parent: root) }
    let(:child) { create(:node, parent: parent) }

    it "returns an empty array if the node has no parents" do
      expect(root.ancestors).to eq([])
    end

    it "returns all ancestors of a node" do
      expect(child.ancestors).to eq([parent, root])
    end
  end
end
