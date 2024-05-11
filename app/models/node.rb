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

  def ancestors
    Node.where(id: ancestor_path).order(id: :desc).to_a
  end

  def lowest_common_ancestor(other)
    return if other.nil?

    (self.ancestors & other.ancestors).first
  end
end
