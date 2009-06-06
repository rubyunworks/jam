require 'nokogiri'

module Jam

  # Nokogiri Adaptor
  #
  class Nokogiri

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
    def remove(node)
      node.remove
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
    def append(ns, child)
      if ::Nokogiri::XML::NodeSet === child
        case ns
        when ::Nokogiri::XML::Node
          ns << child
        when ::Nokogiri::XML::NodeSet
          ns.each do |n|
            n << child
          end
        end
      else
        case ns
        when ::Nokogiri::XML::Node
          ns.content = child
        when ::Nokogiri::XML::NodeSet
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

  end

end

