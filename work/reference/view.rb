#require 'facets/kernel/to_data' # FIXME
require 'cherry/template'

module Cherry

  class View

    def render(file, obj=nil)
      obj ||= self
      data = obj.to_data # TODO convert instance vars to hash?
      tmpl = Template.new(file)
      STDOUT << tmpl.expand(data)
    end

  end

end
