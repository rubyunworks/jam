= Unit Tests for Jam LibXML Adapter

Require adapter.

  require "jam/libxml"

This automatically requires 'libxml' too.

== LibXML::XML::Document

=== #jam

Jam data into a LibXML Document.

  xml = LibXML::XML::Document.string <<-EOS
    <root><x><m id="a">dummy</m><n id="b">dummy</n></x></root>
  EOS

  data = {
    :a => "A",
    :b => "B"
  }

  out = xml.jam(data)
  out = out.root.to_s.gsub(/\n\s*/,'')

  out.should == %{<root><x><m id="a">A</m><n id="b">B</n></x></root>}

== LibXML::XML::Node

=== #jam

Jam data into a LibXML Node.

  xml = LibXML::XML::Document.string <<-EOS
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

== LibXML::XML::XPath::Object

=== #jam

Jam data into the Nodes of a LibXML::XPath::Object.

  xml = LibXML::XML::Document.string <<-EOS
    <root><x><m id="a" class="q">dummy</m><n id="b" class="q">dummy</n></x></root>
  EOS

  nodes = xml.find('.q')

  data = { :a => "A", :b => "B" }

  out = nodes.jam(data)
  out = out.to_s.gsub(/\n\s*/,'')

  out.should == %{<m id="a" class="q">A</m><n id="b" class="q">B</n>}

QED.

