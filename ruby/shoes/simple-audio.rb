
Shoes.app :width => 408, :height => 500 do
  # :resizable => false
  @clip_status = [ false, false, false ]
  
  def disp_clip_status
    result = String.new
    @clip_status.each_index do |i|
      result << "clip #{i}: " + (@clip_status[i] ? " on " : " off ")
    end
    result
  end

  # Toggle play on and off and update status.
  def toggle_play( clip, idx, status )
    if clip.playing?
      clip.stop
    else
      clip.play
    end
    @clip_status[idx] = clip.playing? 
    status.replace("On? #{@clip_status[idx]}")
  end
  
  # background "buddhamachine.gif"
  @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # @bm_clip1.hide
  @bm_clip2 = video "C:/Users/cjansen/Music/Buddha Machine/BM202.mp3"
  # @bm_clip2.hide
  # # @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM202.mp3"
  # @bm_clip1.hide
  # @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # @bm_clip1.hide
  # @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # @bm_clip1.hide
  # @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # @bm_clip1.hide
  # @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # @bm_clip1.hide
  # @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # @bm_clip1.hide
  # @bm_clip1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # @bm_clip1.hide
  stack :margin => 4 do
    @btn1_status = para "On? #{@clip_status[0]}"
    @btn1 = button "1"
    @btn1.click { toggle_play(@bm_clip1, 0, @btn1_status) }
    
    @btn2_status = para "On? #{@clip_status[1]}"
    @btn2 = button "2"
    @btn2.click { toggle_play(@bm_clip2, 1, @btn2_status) }
  #   @btn3 = button "3"
  #   @btn3.click { if @bm_clip3.playing? then @bm_clip3.stop else @bm_clip_3.play  end }
  #   @btn3_status = para "On? #{clip_status[2]}"
  end
  @status = para "Status: #{disp_clip_status}"
  
  # @status = para "Status: " + "clip #{0}: " + (@clip_status[0] ? " on " : " off ")
  # stack :margin => 4 do
  #   @vid1 = video "C:/Users/cjansen/Music/Buddha Machine/BM201.mp3"
  # end
  # para "controls: ",
  #   link("play")  { @vid.play }, ", ",
  #   link("pause") { @vid.pause }, ", ",
  #   link("stop")  { @vid.stop }, ", ",
  #   link("hide")  { @vid.hide }, ", ",
  #   link("show")  { @vid.show }, ", ",
  #   link("+5 sec") { @vid.time += 5000 }
end
