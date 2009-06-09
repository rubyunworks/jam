require 'libxml'
require 'jam/engine'
require 'jam/css_to_xpath'

module LibXML

  class XML::Document
    def jam(data, opts={})
      engine = ::Jam::LibXML.new()
      engine.interpolate(self, data)
    end
  end

  class XML::Node
    def jam(data, opts={})
      engine = ::Jam::LibXML.new()
      engine.interpolate(self, data)
    end
  end

  class XML::XPath::Object
    def jam(data, opts={})
      engine = ::Jam::LibXML.new()
      engine.interpolate(self, data)
    end
  end

end


module Jam

  # LibXML Adaptor
  #
  class LibXML < Engine

    #
    def initialize(*options)
      @options = options
    end

    #
    def document(source)
      ::LibXML::XML::Document.string(source, *@options)
    end

    #
    def search(node, qry)
      qry = Jam.css_to_xpath(qry)
      node.find(qry)
    end

    # deep copy
    def copy(node)
      node.copy(true)
    end

    #
    def remove(node)
      node.remove
    end

    #
    def empty(ns)
      case ns
      when ::LibXML::XML::Node
        ns.content = ''
      when ::LibXML::XML::XPath::Object
        ns.each do |n|
          n.content = ''
        end
      end
    end

    #
    def append(ns, child)
      if ::LibXML::XML::XPath::Object === child
        case ns
        when ::LibXML::XML::Node
          ns << child
        when ::LibXML::XML::XPath::Object
          ns.each do |n|
            n << child
          end
        end
      else
        case ns
        when ::LibXML::XML::Node
          ns.content = child
        when ::LibXML::XML::XPath::Object
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
      case ns
      when ::LibXML::XML::Node
        ns.attr(att, val)
      when ::LibXML::XML::XPath::Object
        ns.each do |n|
          ns.attr(att, val)
        end
      end
    end

    # Iterate over each node.
    #
    def each_node(nodes)
      unless ::LibXML::XML::XPath::Object === nodes
        nodes = [nodes]
      end
      nodes.each do |node|
        yield(node)
      end
    end

  end

end

