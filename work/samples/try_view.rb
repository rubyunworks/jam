require 'markups/view'

class DemoView < MarkUps::View

  def initialize( msg )
    @msg = msg
  end

  def display
    render 'view.html'
  end

end

dv = DemoView.new( "Hello, World!" )
dv.display

