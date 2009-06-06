require 'jam'

tmpl = Jam::Template.new <<-END
  <example id="a"></example>]
END

data = { 'a/@class' => "test" }

out = tmpl.render(data)

puts out

# nested example

tmpl = Jam::Template.new <<-END
  <example id="a"></example>]
END

data = { :a => { '@class' => "test" } }

out = tmpl.render(data)

puts out

