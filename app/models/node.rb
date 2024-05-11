class Node < ApplicationRecord
  belongs_to :parent, class_name: 'Node', optional: true
  has_many :children, class_name: 'Node', foreign_key: 'parent_id'

  before_save :set_ancestor_path

  def set_ancestor_path
    node = self
    self.ancestor_path = []
    while node.parent
      self.ancestor_path << node.parent.id
      node = node.parent
    end
  end

  def family_tree
    @family_tree ||= Node.where(id: ancestor_path).to_a
  end

  def common_ancestors(other)
    return if other.nil?
    return @common_ancestors if @common_ancestors&.include?(other)

    @common_ancestors = CommonAncestors.new(node_a: self, node_b: other)
  end
end
