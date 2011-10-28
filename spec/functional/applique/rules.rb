require 'jam'

When '(((@\w+)))' do |iv, txt|
  instance_variable_set(iv, txt)
end

When 'the result of which should be' do |txt|
  @_.gsub('  ','').strip.assert == txt.gsub('  ','').strip
end

