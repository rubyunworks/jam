require 'jam/nokogiri'
#require 'jam/libxml'

module Jam

  # Jam Templates are data-driven templates. They take
  # valid XML/XHTML documents and expand them based on
  # the data structures provided.
  #
  #--
  # TODO: Should rendered output have document headers like <?xml or a doctype for HTML.
  #++
  class Template
    DEFAULT_ADAPTER = 'Nokogiri'

    attr :engine
    #attr :adapter
    #attr :file

    # New template from source file.
    #
    # * +file+ is the file location of a source.
    # * +adapter+ is either :nokogiri, :libxml or :rexml.
    # * +options+ are per-adapter and passed through to the underlying adapter's parser
    #
    def self.load(file, adapter=DEFAULT_ADAPTER, *options)
      new(File.read(file), adapter, *options)
    end

    # New template from source string.
    #
    # * +source+ can be either a String or an IO object.
    # * +adapter+ is either :nokogiri, :libxml or :rexml.
    # * +options+ are per-adapter and passed through to the underlying adapter's parser
    #
    def initialize(source, adapter=DEFAULT_ADAPTER, *options)
      #@engine  = Engine.new(adapter)
      @engine = Jam.const_get(adapter.to_s).new(*options)
      @source = source
    end

    #
    def document
      @document ||= engine.document(@source)
    end

    #
    # TODO: Should we render as doc, this might add a header, or render as root where it does not.
    #
    def render(data)
      engine.interpolate(document, data).root.to_s
    end

    alias_method :expand, :render

    #
    def to_s
      document.to_s
    end


=begin
    # Interpolate data into document, returning the document object.
    #
    def interpolate(data)
      interpolate_node(data, document)
    end

    #
    def jam(data)
      interpolate_node(data, document)
    end


  private

    # Converts plain keys to css selectors.
    #
    # TODO: Change to use special attribute instead of 'id'?
    #
    def prepare_data(data)
      d = {}
      data.each do |key, val|
        case key.to_s
        when /^<(.*?)>(.*)$/
          d["#{$1}#{$2}"] = val
        when /^\w/
          d["##{key}"] = val
        else
          d[key.to_s] = val
        end
      end
      return d
    end

    # Interpolate data.
    #
    def interpolate_node(data, node)
      case data
      when nil
        adapter.remove(node)
      when Array
        interpolate_sequence(node, data)
      when String, Numeric
        interpolate_scalar(node, data)
      when Hash
        interpolate_mapping(node, data)
      else
        interpolate_object(node, data)
      end
      return node
    end

    # Interpolate object.
    #
    def interpolate_object(node, data)
      data = Hash[data.instance_variables.map{ |iv| [iv[1..-1], data.instance_variable_get(iv)] }]
      interpolate_mapping(node, data)
    end

    # Interpolate mapping.
    #
    def interpolate_mapping(node, data)
      data = prepare_data(data)

      data.each do |id, val|
        att = false
        qry = id.to_s

        result = qry.match(/^((.*?)\/)?([@](.*?))$/);
        if result
          att = result[4]
          qry = result[2] #+ '[@' + att + ']'
        else
          att = false
        end

        if att
          #qry = qry + '[@' + att + ']';
          #search(node,qry).attr(att,val);
          if qry
            #if tag == false
            #  qry = '#' + qry
            #end
            set = adapter.search(node, qry)
            adapter.attribute(set, att, val)
          else
            adapter.attribute(node, att, val)
          end
        else
          set = adapter.search(node, qry)
          if set.size > 0
            interpolate_node(val, set)
          end
        end
      end
    end

    # Interpolate attribute.
    #
    #def interpolate_attribute(nodes, data)
    #
    #end

    # Interpolate array sequence.
    #
    def interpolate_sequence(nodes, data)
      adapter.each_node(nodes) do |node|
        parent = node.parent
        data.each do |new_data|
          new_node = interpolate_node(new_data, node.dup)
          parent << new_node
          node.remove
        end
      end
    end

    # Interpolate value.
    #
    # TODO This should have some special HTML features ?
    #
    # TODO Should we have two modes --one with and one without the extra HTML features?
    #
    def interpolate_scalar(nodes, data)
      #var all_special = new Array;

      # text inputs
      #var special = this.find('input[@type=text]');
      #special.val(data.toString());
      #all_special.concat(special);
      # textarea
      # TODO

      #this.not(special).empty();
      #this.not(special).append(data.toString());
      #alert(data);
      #adapter.empty(node)
      adapter.replace(nodes, data.to_s)
    end
=end

  end #class Template

end #module Jam



=begin
# Interpolate list.

function interpolate_list(node, data) {
  temp = node.copy(true)
  node.empty!
  for (var d in data) {
    nc = temp.copy(true);
    interpolate_children( nc, d )
    for (var c in nc.children) {
      node.add(c);
    };
  };
};
=end


