=begin
	The main cipher window
=end
str = ""
t = nil
@note = Array.new
Shoes.app :height => 500, :width => 450 do
  stack :width => 445 do
    background "#eee", :curve => 12
    border "#00D0FF", :strokewidth => 3, :curve => 12
	caption "Editor"
	@edit = edit_box "Hi there", :width => 1.0, :height => 200, :margin_bottom => 20 do
		@note[1] = @edit.text
	end
  end
end
