= Jam Template Interpolation

Load the template library.

  require 'jam'

== Nokogiri

Run samples through Nokogiri adapter.

  table('samples.yaml') do |sample|
    tmp = Jam::Template.new(sample['template'])
    out = tmp.expand(sample['data']).gsub(/\n\s*/,'')
    out.should == sample['result']
  end

== Hpricot

Run samples through Hpricot adapter.

  table('samples.yaml') do |sample|
    tmp = Jam::Template.new(sample['template'])
    out = tmp.expand(sample['data']).gsub(/\n\s*/,'')
    out.should == sample['result']
  end

QED.

