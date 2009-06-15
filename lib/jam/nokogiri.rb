require 'nokogiri'
require 'jam/engine'

module Nokogiri

  class XML::Document
    def jam(data, opts={})
      engine = ::Jam::Nokogiri.new()
      engine.interpolate(self, data)
    end
  end

  class XML::Node
    def jam(data, opts={})
      engine = ::Jam::Nokogiri.new()
      engine.interpolate(self, data)
    end
  end

  class XML::NodeSet
    def jam(data, opts={})
      engine = ::Jam::Nokogiri.new()
      engine.interpolate(self, data)
    end
  end

end


module Jam

  # Nokogiri Adaptor
  #
  class Nokogiri < Engine

    #
    def initialize(*options)
      @options = options
    end

    # Contruct XML document given source text.
    #
    def document(source)
      ::Nokogiri::XML(source, *@options)
    end

    # Use CSS or XPath to search node.
    #
    def search(node, qry)
      node.search(qry)
    end

    # Deep copy.
    #
    def copy(node)
      node.dup 
    end

    # Empty nodes.
    #
    def empty(node_or_nodeset)
      case node_or_nodeset
      when ::Nokogiri::XML::Node
        node_or_nodeset.content = ''
      when ::Nokogiri::XML::NodeSet
        ns.each do |n|
          node_or_nodeset.content = ''
        end
      end
    end

    # Append child to node(s).
    #
    def append(node_or_nodeset, child)
      ns = node_or_nodeset
      case child
      when ::Nokogiri::XML::Node
        each_node(node_or_nodeset) do |node|
          node << child
        end
      when ::Nokogiri::XML::NodeSet
        child.each do |n|
          each_node(node_or_nodeset) do |node|
            node << n.dup
          end
        end
      else
        append_text(node_or_nodeset, child)        
      end
    end

    # TODO
    def append_text(node_or_nodeset, text)
    end

    # TODO: rename to replace_content
    #def replace(ns, child)
    #  empty(ns)
    #  append(ns, child)
    #end

    # Replace node content with text.
    #
    def replace_content_with_text(node_or_nodeset, text)
      each_node(node_or_nodeset) do |node|
        node.content = text
      end
    end

    # Remove node.
    #
    def remove(node)
      node.remove
    end

    # Set an attribute.
    #
    def attribute(ns, att, val)
      case ns
      when ::Nokogiri::XML::Node
        ns.attr(att, val)
      when ::Nokogiri::XML::NodeSet
        ns.each do |n|
          ns.attr(att, val)
        end
      end
    end

    # Remove jam nodes that ask for it, and all jam attributes.
    #
    def cleanup(node)
      node = node.root if ::Nokogiri::XML::Document === node
      # remove unwanted tags
      node.xpath("//*[@jam='erase']").each do |n|
        unwrap(n)
      end
      # remove jam attributes

      #
      node
    end

    # Iterate over each node.
    #
    def each_node(nodes)
      unless ::Nokogiri::XML::NodeSet === nodes
        nodes = [nodes]
      end
      nodes.each do |node|
        yield(node)
      end
    end

    # Unwrap a node, such that the outer tag is
    # removed, leaving only it's own children.
    #
    def unwrap(node)
      node.children.each do |child|
       node.parent << child
      end
      node.remove
    end

  end

end #module Jam

