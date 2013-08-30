##
# Shortcut method for creating a text node.
#
def text_node(*args)
  return Opener::KafParser::AST::Text.new(*args)
end

##
# Shortcut method for creating document nodes.
#
def document_node(*args)
  return Opener::KafParser::AST::Document.new(*args)
end

##
# Shortcut method for creating opinion nodes.
#
def opinion_node(*args)
  return Opener::KafParser::AST::Opinion.new(*args)
end
