require 'jam'

tmpl = Jam::Template.new <<-END
  <example id="a"></example>]
END

data = { :a => "Hello World" }

out = tmpl.render(data)

puts out

