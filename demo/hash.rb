require 'jam'

tmpl = Jam::Template.new <<-END
<html>
  <body>
    <h1 id="title">title will be inserted here</h1>
    <p id="body">body text will be inserted here</p>
  </body>
</html>
END

data = {
  :title => "hello world",
  :body => "Amrita is a html template libraly for Ruby"
}

out = tmpl.expand(data)

puts out

