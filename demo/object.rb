require 'jam'

class A
  attr :a
  def initialize
    @a = "A"
  end
end

tmpl = Jam::Template.new <<-END
  <example id="a"></example>]
END

data = A.new

out = tmpl.render(data)

puts out

