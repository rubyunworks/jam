require 'hrpicot'
require 'jam/engine'

module Hpricot

  class Doc
    def jam(data, opts={})
      engine = ::Jam::Hpricot.new()
      engine.interpolate(self, data)
    end
  end

  class XML::Node
    def jam(data, opts={})
      engine = ::Jam::Hpricot.new()
      engine.interpolate(self, data)
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
      ::Hpricot(source, *@options)
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
      if ::Hpricot::Elements === child
        case ns
        #when ::Nokogiri::XML::Node
        #  ns << child
        when ::Hpricot::Elements
          ns.each do |n|
            n << child
          end
        end
      else
        case ns
        #when ::Nokogiri::XML::Node
        #  ns.content = child
        when ::Hpricot::Elements
          ns.each do |n|
            n.content = child
          end
        end
      end
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
    def attribute(ns, att, val)
      ns.set(att, val)
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

