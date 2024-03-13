class Admin::PositionUpdaterController < Admin::ResourceController
  def update_position
    @position = 1
    update_tree params[:nodes]

    render nothing: true
  end

  def update_tree(nodes, parent_node = nil)
    nodes.each do |key, value|
      node = resource_class.find_by(id: value[:id])
      node.parent = parent_node if node.respond_to? :parent

      node.position = @position
      @position += 1
      node.save!(validate: false)

      update_tree(value[:children], node) if value.has_key? 'children'
    end
  end
end
