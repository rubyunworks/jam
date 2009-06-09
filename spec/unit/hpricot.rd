= Unit Tests for Jam Nokogiri Adapter

Require adapter.

  require "jam/hpricot"

This automatically requires 'hpricot' too.

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

Jam data into a Nokogiri Node.

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

