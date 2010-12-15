--- 
name: jam
company: RubyWorks
repositories: 
  public: git://github.com/rubyworks/jam.git
title: Jam
contact: Trans <transfire@gmail.com>
requires: 
- group: 
  - build
  name: syckle
  version: 0+
resources: 
  home http://rubyworks.github.com/jam code: http://github.com/rubyworks/jam
  mail: http://groups.google.com/group/rubyworks-mailinglist
pom_verison: 1.0.0
manifest: 
- .ruby
- bin/jam
- demo/array.rb
- demo/attribute.rb
- demo/demi/fixtures/ex1.html
- demo/demi/fixtures/samples.yaml
- demo/demi/integration/01_jam.rd
- demo/demi/integration/02_xpath.rd
- demo/demi/integration/samples.rd
- demo/demi/unit/hpricot.rd
- demo/demi/unit/libxml.rd
- demo/demi/unit/nokogiri.rd
- demo/demi/unit/rexml.rd
- demo/hash.rb
- demo/helloworld.rb
- demo/object.rb
- demo/table.rb
- lib/jam/cherry.rb
- lib/jam/css2xpath.rb
- lib/jam/css_to_xpath.rb
- lib/jam/engine.rb
- lib/jam/hpricot.rb
- lib/jam/libxml.rb
- lib/jam/nokogiri.rb
- lib/jam/rexml.rb
- lib/jam/template.rb
- lib/jam.rb
- TODO
- README
- HISTORY
- VERSION
version: 0.2.0
copyright: Copyright (c) 2008 Thomas Sawyer
licenses: 
- Apache 2.0
description: Jam is a data-driven template system.
summary: Jam is a data-driven template system.
authors: 
- Thomas Sawyer
created: 2008-12-16
