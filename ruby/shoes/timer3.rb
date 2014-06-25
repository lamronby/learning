Shoes.app :height => 150, :width => 250 do
  background rgb(240, 250, 208)
  stack :margin => 10 do
	  @start_btn = button "Start"
	  @start_btn.click do |btn|
		  alert btn.style.inspect
		  btn.hide
		  alert btn.style.inspect
		  btn.style(:text => "")
		  alert btn.style.inspect
		  btn.style(:text => "Foo loo Foo loo")
		  alert btn.style.inspect
		  btn.show
		  alert btn.style.inspect
        @time = Time.now
        @label.replace "Stop watch started at #@time"
	  end
	  @stop_btn = button "Stop"
	  @stop_btn.click do |btn|
		  btn.clear
		  btn.style(:text => "Blah Blah")
        @label.replace "Stopped, ", strong("#{Time.now - @time}"), " seconds elapsed."
      end
    @label = para "Press ", strong("start"), " to begin timing."
  end
end
