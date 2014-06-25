Shoes.app :width => 280, :height => 350 do
	flow :width => 280, :margin => 10 do
		stack :width => "100%" do
			banner "A POEM"
		end
		stack :width => "80 px" do
			para "Goes like:"
		end
		stack :width => "-90px" do
			para "the sun.\n",
			  "a lemon.\n",
			  "the goalie.\n"
		  end
	end
end
