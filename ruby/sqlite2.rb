#!/usr/bin/ruby

require 'sqlite3'

begin
    
    db = SQLite3::Database.open "ThisAmericanLife.db"
    stm = db.prepare "SELECT * FROM TAL Where EpisodeNumber = ?"
    stm.bind_param 1, "499"
    rs = stm.execute 
    
    rs.each do |row|
        puts row.join "\s"
    end
    
rescue SQLite3::Exception => e 
    
    puts "Exception occured"
    puts e
    
ensure
    stm.close if stm
    db.close if db
end
