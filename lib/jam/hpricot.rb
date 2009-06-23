require 'hpricot'
require 'jam/engine'

module Hpricot

  class Doc
    def jam(data, opts={})
      engine = ::Jam::Hpricot.new()
      engine.interpolate(self, data)
    end
  end

  class Elem
    # This turns the Elem into an Elements object containing it.
    def jam(data, opts={})
      engine = ::Jam::Hpricot.new()
      engine.interpolate(::Hpricot::Elements[self], data)
    end
  end

  class Elements
    def jam(data, opts={})
      engine = ::Jam::Hpricot.new()
      engine.interpolate(self, data)
    end
  end

end

module Jam

  # Hpricot Adaptor
  #
  class Hpricot < Engine

    #
    def initialize(*options)
      @options = options
    end

    #
    def document(source)
      ::Hpricot.parse(source) #, *@options)
    end

    #
    def search(node, qry)
      node.search(qry)
    end

    # deep copy # TODO: works?
    def copy(node)
      node.dup 
    end

    #
    def remove(node)
      node.remove
    end

    #
    def empty(ns)
      ns.empty
    end

    #
    def append(ns, child)
      ns.append(child.to_s)
    end

    #
    def replace(ns, child)
      empty(ns)
      append(ns, child)
    end

    #
    def remove(node)
      node.remove
    end

    #
    def replace_content_with_text(node, text)
      case node
      when ::Hpricot::Elements
        node.inner_html = text
      when ::Array
        node.each do |n|
          n.inner_html = text
        end
      else

      end
    end

    #
    def attribute(ns, att, val)
      ns.set(att, val)
    end

    # Remove jam nodes that ask for it, and all jam attributes.
    #
    def cleanup(node)
      #node = node.root if ::Nokogiri::XML::Document === node
      # remove unwanted tags
      node.search("//*[@jam='erase']").each do |n|
        unwrap(n)
      end
      # remove jam attributes

      #
      node
    end

    # Unwrap a node, such that the outer tag is
    # removed, leaving only it's own children.
    #
    def unwrap(node)
      node.each_child{ |n| node.parent.insert_before(n, node) }
      ::Hpricot::Elements[node].remove
    end

    # Iterate over each node.
    #
    def each_node(nodes)
      unless ::Hpricot::Elements === nodes
        nodes = [nodes]
      end
      nodes.each do |node|
        yield(node)
      end
    end

  end

end

