require 'rexml/document'
require 'jam/engine'
require 'jam/css2xpath'

module REXML

  class Document
    def jam(data, opts={})
      engine = ::Jam::REXML.new()
      engine.interpolate(self, data)
    end
  end

  class Element
    def jam(data, opts={})
      engine = ::Jam::REXML.new()
      engine.interpolate(self, data)
    end
  end

  class XPath
    def self.jam(node, data)
     engine = ::Jam::REXML.new()
     engine.interpolate(node, data)
    end
  end

end


module Jam

  # REXML Adaptor
  #
  class REXML < Engine

    #
    def initialize(*options)
      @options = options
    end

    #
    def document(source)
      ::REXML::Document.new(source, *@options)
    end

    #
    def search(node, qry)
      qry = Jam.css_to_xpath(qry)
      ::REXML::XPath.match(node, qry)
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
      when ::REXML::Element
        ns.inner_html = ''
      when Array
        ns.each do |n|
          n.inner_html = ''
        end
      end
    end

    #
    def append(ns, child)
      if Array === child
        case ns
        when ::REXML::Element
          ns.add_element(child)
        when Array
          ns.each do |n|
            nadd_element(child)
          end
        end
      else
        case ns
        when ::REXML::Element
          ns.add_element(child)
        when Array
          ns.each do |n|
            n.add_element(child)
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
      when ::REXML::Element
        ns.attr(att, val)
      when Array
        ns.each do |n|
          ns.attr(att, val)
        end
      end
    end

    # Iterate over each node.
    #
    def each_node(nodes)
      unless Array === nodes
        nodes = [nodes]
      end
      nodes.each do |node|
        yield(node)
      end
    end

  end

end #module Jam

