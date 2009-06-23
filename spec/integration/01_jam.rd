= Jam Template Interpolation

Load the template library.

  require 'jam'

== Hash

Template rendering with a basic hash.

  tmpl = Jam::Template.new <<-EOS
    <x><y><m id="a">dummy</m><n id="b">dummy</n></y></x>
  EOS

  data = {
    :a => "A",
    :b => "B"
  }

  out = tmpl.expand(data).gsub(/\n\s*/,'')

  out.should == %{<x><y><m id="a">A</m><n id="b">B</n></y></x>}

== Lists

Template rendering with an Array.

  tmpl = Jam::Template.new <<-EOS
    <x><y><m id="a">dummy</m></y></x>
  EOS

  data = {
    :a => [ "A", "B", "C" ]
  }

  out = tmpl.expand(data).gsub(/\n\s*/,'')

  out.should == %{<x><y><m id="a">A</m><m id="a">B</m><m id="a">C</m></y></x>}

QED.

