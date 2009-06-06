= Unit Tests for Jam Nokogiri Adapter

Require adapter.

  require "jam/nokogiri"

This automatically requires 'nokogiri' too.

== Nokogiri::Document

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

== Nokogiri::Node

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

== Nokogiri::NodeSet

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


