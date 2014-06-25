Shoes.app do
  background rgb(0, 0, 0)
  fill rgb(255, 255, 255)
  flow :width => "95%" do
      rects_l = [
        rect(0, 0, 45, 45),
        rect(0, 51, 50, 50),
        rect(0, 102, 55, 55)
      ] 
  end
   flow :width => "95%" do
       rects_m = [
         rect(0, 120, 55, 55),
         rect(57, 120, 50, 50),
         rect(107, 120, 45, 45)
       ] 
   end
end
