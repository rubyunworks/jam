require 'facets/hash/to_h'
require ''

module Jimmy

  # Jimmy Templates are data-driven templates. They take
  # valid XML/XHTML documents and expand them based on
  # the data strucurres provided.

  class Template

    attr :adapter
    attr :file

    # +file+ is the file location of a source.
    # +adapter+ is either :rexml or :libxml.

    def self.load( file, adapter=:rexml )
      new( File.new( file ), adapter )
    end

    # +source+ can be either a String or an IO.
    # +adapter+ is either :rexml or :libxml.

    def initialize( source, adapter=:rexml )
      @adapter = adapter
      @source = source #str_or_io
    end

    def expand( data )
      doc = parse( data ).document
      doc.to_s
    end

    def parse( data )
      root = RQuery::Xml.new( @source )
      interpolate( root, data )
      root
    end

    # Interpolate data.

    def interpolate( node, data )
      case data
      when Hash
        data.to_h.each do |id, content|
          matches = node.search( "/descendant::*[@id='#{id}']" )
          match_node = matches[0]
          next unless match_node
          case content
          when Hash
            interpolate( match_node, content )
          when Array
            interpolate_list( match_node, content )
            #case content[0]
            #when Hash
            #  interpolate_table( match_node, content )
            #else
            #  interpolate_list( match_node, content )
            #end
          when FalseClass
            match_node.remove!
          when NilClass
            # do nothing
          else
            interpolate_node( match_node, content )
          end
        end
      else
        interpolate_node( node, data.to_s )
      end
    end

    # Interpolate each child.

    def interpolate_children( node, data )
      node.each do |n|
        interpolate( n, data ) if n.element?
      end
    end

    # Interpolate list.

    def interpolate_list( node, data )
      temp = node.copy(true)
      node.empty!
      data.each do |d|
        nc = temp.copy(true)
        interpolate_children( nc, d )
        nc.children.each { |c| node.add( c ) }
      end
    end

    #alias interpolate_table interpolate_list

    # This has a couple of special HTML features. TODO have two versions?

    def interpolate_node( node, data )
      case node.name.downcase
      when 'input'
        if node['type'].downcase == 'text'
          node['value'] = data.to_s
        end
      else
        node.content = data.to_s
      end
    end

  end

end

