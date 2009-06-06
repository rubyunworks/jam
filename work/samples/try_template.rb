require 'rquery/template'

__DIR__ = File.expand_path(File.dirname(__FILE__))
__DOC__ = File.join(__DIR__, 'data', 'template.html')

RQuery.adapter( :rexml )

table = {
  :thunk => "I think",
  :list => [ 1,2,3 ],
  :table => [
    { :table_name => "John", :table_address => "123 Test Ln." },
    { :table_name => "Mary", :table_address => "895 Upper Rd." }
  ],
  :remove_me => false
}


tmpl = RQuery::Template.new(__DOC__)
r = tmpl.expand(table)
puts r unless $DEBUG

