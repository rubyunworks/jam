require 'jam'

tmpl = Jam::Template.new <<-END
<example>
  <ul><li id="list"></ul>
</example>
END

data = { :list => %w{ A B C } }

out = tmpl.expand(data)

puts out

