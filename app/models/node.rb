class Node < ApplicationRecord
  belongs_to :parent, class_name: 'Node', optional: true
  has_many :children, class_name: 'Node', foreign_key: 'parent_id'

  def ancestors
    node = self
    result = []
    while node.parent
      result << node.parent
      node = node.parent
    end
    result
  end

  def lowest_common_ancestor(other)
    return if other.nil?

    (self.ancestors & other.ancestors).first
  end
end
