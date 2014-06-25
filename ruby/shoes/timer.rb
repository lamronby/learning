=begin
  A timer application.
=end


# , :resizable => false 
Shoes.app :width => 250, :height => 200 do
  background '#222'..'#aaa'
  @running = false

  # Update the displayed time
  def update_time_display
    @seconds = Time.now - @time
    @time_display.replace '%3.03f' % @seconds
  end

  # Reset the timer
  def reset
    @seconds = 0
    @time = Time.now
    update_time_display
  end

  stack :margin => 10 do
    
      @time_display = title '%3.03f' % 0, :stroke => white, :align => 'center'

    @box = flow do
      @start = button "Start" do |btn| 
        @running = true
        @time = Time.now
        @label.replace "Stop watch started at #{@time.strftime('%H:%M:%S')}"
        btn.state = 'disabled'
        @stop.state = nil
        @stop.focus()
      end
      @stop = button "Stop" do |btn|
        @running = false
        @label.replace "Stopped, ", strong("#{Time.now - @time}"), " seconds elapsed."
        btn.state = 'disabled'
        @start.state = nil
        @start.focus()
      end
      @reset = button "Reset" do
        reset
        update_time_display
      end
    end
    
    @label = para "Press ", strong("start"), " to begin timing."
    @start.focus()
  end

  animate(10) do |frm|
    # @label.replace = para "In animation, #{frm}, running=#{@running}"
    update_time_display if @running
  end

end



