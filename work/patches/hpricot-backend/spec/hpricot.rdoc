= Unit Tests for Jam Hpricot Adapter

Require adapter.

  require "jam/hpricot"

This automatically requires 'hpricot' too.

== Jam::Hpricot

Support objects for following tests.

  @xml = "<root><a>A</a><b>B</b><c>C</c></root>"
  @eng = Jam::Hpricot.new

BEFORE: We will resuse this XML document.

  before {
    @doc = @eng.document(@xml)
  }

=== #append

Append should be able to append an XML node.

  node  = @doc.search('root')
  node2 = node.search('a').dup

  @eng.append(node, node2)

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>A</a><b>B</b><c>C</c><a>A</a></root>'

Append should be able to append a set of nodes.

  node       = @doc.search('root')
  nodeset    = @doc.search('root/*')

  @eng.append(node, nodeset)

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>A</a><b>B</b><c>C</c><a>A</a><b>B</b><c>C</c></root>'

Append should be able to append an XML text fragment.

  node = @doc.search('root')

  @eng.append(node, '<d>D</d>')

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>A</a><b>B</b><c>C</c><d>D</d></root>'

=== #replace_content_with_text

It should replace node children with given text.

  node = @doc.search('root')

  @eng.replace_content_with_text(node, 'H')

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root>H</root>'

It should be able to replace the children of each node of a NodeSet with text.

  node    = @doc.root
  nodeset = @doc.root.children

  @eng.replace_content_with_text(nodeset, 'H')

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>H</a><b>H</b><c>H</c></root>'

=== #cleanup

This will clean a document, or node, of any elements that request it.

  doc = @eng.document('<root><a jam="erase">This is text.</a></root>')

  @eng.cleanup(doc)

  out = doc.root.to_s.gsub(/\n\s*/,'')
  out.should == '<root>This is text.</root>'


== Hpricot::Doc

=== #jam

Jam data into a Hpricot Document.

  xml = Hpricot(%{
    <root><x><m id="a">dummy</m><n id="b">dummy</n></x></root>
  })

  data = {
    :a => "A",
    :b => "B"
  }

  out = xml.jam(data)
  out = out.root.to_s.gsub(/\n\s*/,'')

  out.should == %{<root><x><m id="a">A</m><n id="b">B</n></x></root>}

== Hpricot::Elem

=== #jam

Jam data into a Hpricot Node.

  xml = Hpricot(%{
    <root><x><m id="a">dummy</m><n id="b">dummy</n></x></root>
  })

  node = xml.root

  data = {
    :a => "A",
    :b => "B"
  }

  out = node.jam(data)
  out = out.to_s.gsub(/\n\s*/,'')

  out.should == %{<root><x><m id="a">A</m><n id="b">B</n></x></root>}

== Hpricot::Elements

=== #jam

Jam data into a Hpricot Elements.

  xml = Hpricot(%{
    <root><x><m id="a" class="q">dummy</m><n id="b" class="q">dummy</n></x></root>
  })

  nodeset = xml.search('.q')

  p nodeset.search('#a')

  data = { :a => "A", :b => "B" }

  out = nodeset.jam(data)
  out = out.to_s.gsub(/\n\s*/,'')

  out.should == %{<m class="q" id="a">A</m><n class="q" id="b">B</n>}

QED.

