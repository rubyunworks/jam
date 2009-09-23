= Unit Tests for Jam REXML Adapter

Require adapter.

  require "jam/rexml"

This automatically requires 'rexml/document' too.

== REXML::Document

=== #jam

Jam data into a REXML Document.

  xml = REXML::Document.new <<-EOS
    <root><x><m id="a">dummy</m><n id="b">dummy</n></x></root>
  EOS

  data = {:a => "A", :b => "B"}

  out = xml.jam(data)
  out = out.root.to_s.gsub(/\n\s*/,'')

  out.should == %{<root><x><m id="a">A</m><n id="b">B</n></x></root>}

== REXML::Node

=== #jam

Jam data into a REXML Node.

  xml = REXML::Document.new <<-EOS
    <root><x><m id="a">dummy</m><n id="b">dummy</n></x></root>
  EOS

  node = xml.root

  data = {:a => "A", :b => "B"}

  out = node.jam(data)
  out = out.to_s.gsub(/\n\s*/,'')

  out.should == %{<root><x><m id="a">A</m><n id="b">B</n></x></root>}

== REXML::XPath

=== #jam_each

Jam data into the nodes of a REXML::XPath object.

  xml = REXML::Document.new <<-EOS
    <root><x><m id="a" class="q">dummy</m><n id="b" class="q">dummy</n></x></root>
  EOS

  data = { :a => "A", :b => "B" }

  out = REXML::XPath.jam(xml, data)
  out = out.to_s.gsub(/\n\s*/,'')

  out.should == %{<m id="a" class="q">A</m><n id="b" class="q">B</n>}

QED.

