require 'jam'

tmpl = Jam::Template.new <<-END
<table border="1">
  <tr><th>name</th><th>author</th></tr>
  <tr id="table1">
    <td id="name"></td>
    <td id="author"></td>
  </tr>
</table>
END

data = {
  :table1=>[ 
    { :name=>"Ruby",   :author=>"Matz" },
    { :name=>"Perl",   :author=>"Larry Wall" },
    { :name=>"Python", :author=>"Guido van Rossum" }
  ]
}

out = tmpl.expand(data)

puts out

