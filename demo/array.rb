require 'jam'

t = <<-END
  <example>
    <ul><li id="list"></li></ul>
  </example>
END

tmpl = Jam::Template.new t, "LibXML"

data = { :list => %w{ A B C } }

out = tmpl.expand(data)

puts out

