require 'sqlite3'
Shoes.app :width => 350, :height => 130 do
  title "This American Life"
  db = SQLite3::Database.open "C:/learning/ruby/ThisAmericanLife.db"
  rows = db.execute "select * from TAL limit 10"
  para "${rows.count} rows"
  #rows.each{|k, d, n, p| para "#{k} f: #{d} : #{n} : #{p}\n"}
  rows.each{|k, d, n, p| para "#{k} : #{d} : #{n} : #{p}\n"}
end