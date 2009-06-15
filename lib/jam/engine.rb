#require 'facets/hash/to_h'

module Jam

  # = Jam Engine
  #
  # The Engine class serves as the base class for the various Jam adapters.
  #
  #--
  # TODO: Can we normalize parser options across all backends. REXML seems a limiting factor.
  #++

  class Engine

    # Interpolate data into document, returning the document object.
    #
    def interpolate(node, data)
      interpolate_node(node, data)
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
    def interpolate_node(node, data)
      case data
      when nil
        remove(node)
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
            nodeset = search(node, qry)
            attribute(nodeset, att, val)
          else
            attribute(node, att, val)
          end
        else
          nodeset = search(node, qry)
          #if nodeset.size > 0
            interpolate_node(nodeset, val)
          #end
        end
      end
    end

    # Interpolate object.
    #
    def interpolate_object(node, data)
      data = Hash[data.instance_variables.map{ |iv| [iv[1..-1], data.instance_variable_get(iv)] }]
      interpolate_mapping(node, data)
    end

    # Interpolate attribute.
    #
    #def interpolate_attribute(nodes, data)
    #
    #end

    # Interpolate array sequence.
    #
    def interpolate_sequence(nodes, data)
      each_node(nodes) do |node|
        parent = node.parent
        data.each do |new_data|
          new_node = interpolate_node(node.dup, new_data)
          append(parent, new_node)
          remove(node)
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
      #empty(node)
      replace_content_with_text(nodes, data.to_s)
    end

  end #class Engine

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


