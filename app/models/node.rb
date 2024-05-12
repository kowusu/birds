class Node < ApplicationRecord
  belongs_to :parent, class_name: 'Node', optional: true
  has_many :children, class_name: 'Node', foreign_key: 'parent_id'

  def ancestors
    Rails.cache.fetch("#{cache_key_with_version}/ancestors", expires_in: 12.hour) do
      sql = <<-SQL
        WITH RECURSIVE ancestors AS (
            SELECT *
            FROM nodes
            WHERE id = :start_node_id
          UNION ALL
            SELECT n.*
            FROM nodes n
            JOIN ancestors a ON a.parent_id = n.id
        )
        SELECT * FROM ancestors WHERE id != :start_node_id;
      SQL

      Node.find_by_sql([sql, start_node_id: id])
    end
  end

  def common_ancestors(other)
    return if other.nil?
    return @common_ancestors if @common_ancestors&.include?(other)

    @common_ancestors = CommonAncestors.new(node_a: self, node_b: other)
  end

  def self.find_node_ids_with_descendant_ids(node_ids)
    sorted_node_ids = node_ids.sort
    cache_key = "nodes/descendants/#{sorted_node_ids.join('-')}"

    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      sql = <<-SQL
        WITH RECURSIVE descendant_nodes AS (
            SELECT id, parent_id
            FROM nodes
            WHERE id IN (:node_ids)
          UNION ALL
            SELECT n.id, n.parent_id
            FROM nodes n
            JOIN descendant_nodes d ON n.parent_id = d.id
        )
        SELECT DISTINCT * FROM descendant_nodes;
      SQL

      find_by_sql([sql, node_ids: node_ids]).pluck(:id)
    end
  end
end
