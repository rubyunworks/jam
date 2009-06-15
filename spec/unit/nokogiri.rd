= Unit Tests for Jam Nokogiri Adapter

Require adapter.

  require "jam/nokogiri"

This automatically requires 'nokogiri' too.

== Jam::Nokogiri

Support objects for following tests.

  @xml = "<root><a>A</a><b>B</b><c>C</c></root>"
  @eng = Jam::Nokogiri.new

BEFORE: We will resuse this XML document.

  @doc = @eng.document(@xml)

=== #append

Append should be able to append an XML node.

  node  = @doc.root
  node2 = node.children[0].dup

  @eng.append(node, node2)

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>A</a><b>B</b><c>C</c><a>A</a></root>'

Append should be able to append a NodeSet.

  node    = @doc.root
  nodeset = @doc.root.children.dup

  @eng.append(node, nodeset)

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>A</a><b>B</b><c>C</c><a>A</a><b>B</b><c>C</c></root>'

Append should be able to append an XML text fragment.

  node = @doc.root

  @eng.append(node, '<d>D</d>')

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>A</a><b>B</b><c>C</c><d>D</d></root>'

== #replace_with_text

It should replace node children with given text.

  node = @doc.root

  @eng.replace_with_text(node, 'H')

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root>H</root>'

It should be able to replace the children of each node of a NodeSet with text.

  node    = @doc.root
  nodeset = @doc.root.children

  @eng.replace_with_text(nodeset, 'H')

  out = node.to_s.gsub(/\n\s*/,'')
  out.should == '<root><a>H</a><b>H</b><c>H</c></root>'

== ::Nokogiri::Document

=== #jam

Jam data into a Nokogiri Document.

  xml = Nokogiri::XML <<-EOS
    <root><x><m id="a">dummy</m><n id="b">dummy</n></x></root>
  EOS

  data = {
    :a => "A",
    :b => "B"
  }

  out = xml.jam(data)
  out = out.root.to_s.gsub(/\n\s*/,'')

  out.should == %{<root><x><m id="a">A</m><n id="b">B</n></x></root>}

== ::Nokogiri::Node

=== #jam

Jam data into a Nokogiri Node.

  xml = Nokogiri::XML <<-EOS
    <root><x><m id="a">dummy</m><n id="b">dummy</n></x></root>
  EOS

  node = xml.root

  data = {
    :a => "A",
    :b => "B"
  }

  out = node.jam(data)
  out = out.to_s.gsub(/\n\s*/,'')

  out.should == %{<root><x><m id="a">A</m><n id="b">B</n></x></root>}

== ::Nokogiri::NodeSet

=== #jam

Jam data into a Nokogiri Node.

  xml = Nokogiri::XML <<-EOS
    <root><x><m id="a" class="q">dummy</m><n id="b" class="q">dummy</n></x></root>
  EOS

  nodeset = xml.search('.q')

  p nodeset.search('#a')

  data = { :a => "A", :b => "B" }

  out = nodeset.jam(data)
  out = out.to_s.gsub(/\n\s*/,'')

  out.should == %{<m id="a" class="q">A</m><n id="b" class="q">B</n>}

QED.

