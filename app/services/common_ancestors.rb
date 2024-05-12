class CommonAncestors
  
  def initialize(node_a: , node_b: )
    @node_a = node_a
    @node_b = node_b
  end

  def common_ancestors
    return [] if @node_a.nil? || @node_b.nil?
    return @node_a.ancestors + [@node_a] if @node_a == @node_b
    @common_ancestors ||= (@node_a.ancestors & @node_b.ancestors)
  end

  def lowest
    common_ancestors&.last
  end

  def root
    common_ancestors&.first
  end

  def depth
    return if common_ancestors.empty?
    common_ancestors&.length
  end

  def include?(node)
    [@node_a, @node_b].include?(node)
  end
end