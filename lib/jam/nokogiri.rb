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

    #
    def document(source)
      ::Nokogiri::XML(source, *@options)
    end

    #
    def search(node, qry)
      node.search(qry)
    end

    # deep copy
    def copy(node)
      node.dup 
    end

    #
    def empty(ns)
      case ns
      when ::Nokogiri::XML::Node
        ns.inner_html = ''
      when ::Nokogiri::XML::NodeSet
        ns.each do |n|
          n.inner_html = ''
        end
      end
    end

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

    #
    def replace(ns, child)
      empty(ns)
      append(ns, child)
    end

    # Replace node content with text.
    #
    def replace_content_with_text(node_or_nodeset, text)
      each_node(node_or_nodeset) do |node|
        node.content = text
      end
    end

    # Remove node.
    def remove(node)
      node.remove
    end

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

    # Remove jam nodes that ask for it, and all jam attributes.
    #
    def cleanup(node)
      node = node.root if ::Nokogiri::XML::Document === node
      # remove unwanted tags
      node.xpath("//*[@jam='erase']").each do |n|
        n.children.each do |c|
          n.add_previous_sibling(c)
        end
        n.remove
      end
      # remove jam attributes

      #
      node
    end

  end

end #module Jam

