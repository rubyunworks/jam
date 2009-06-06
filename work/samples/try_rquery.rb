require 'rquery/xml'

adapter = :rexml

__DIR__ = File.expand_path(File.dirname(__FILE__))
__XML__ = File.join(__DIR__, 'data', 'rquery.xml')

puts
puts '*******************************'
puts '*  Demo of RQuery XML   /\    *'
puts '*                     ( )( )  *'
puts '*******************************'
puts
puts "On File: fixture/rquery.xml"
puts
puts "RQuery.adapter(#{adapter})"
puts "=> #{RQuery.adapter(adapter)}"
puts
puts "root = RQuery::Xml.load(#{__XML__})"
puts "=> #{root = RQuery::Xml.load(__XML__)}"
puts
puts "root['title']"
puts "=> #{root['title']}"
puts
puts "root/:section"
puts "=> #{root / :section}"
puts
puts "root/:section/:item"
puts "=> #{root / :section / :item}"
puts

#q2 = q / 'item#12'

#q2.each { |n|
#  p n
#}

