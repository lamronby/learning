=begin
 Exercise2. Write a Ruby program that analyzes a .mp3 file. Many MP3
 files have a 128-byte data structure at the end called an ID3 tag. These 128
 bytes are literally packed with information about the song: its name, the artist, which album it’s from, and so on. You can parse this data structure by
 opening an MP3 file and doing a series of reads from a pos near the end of the
 file. According to the ID3 standard, if you start from the 128th-to-last byte
 of an MP3 file and read three bytes, you should get the string “TAG”. If you
 don’t, there’s no ID3 tag for this MP3 file, and nothing to do. If there is an
 ID3 tag present, then the 30 bytes after “TAG” contain the name of the song,
 the 30 bytes after that contain the name of the artist, and so on. A sample
 song.mp3 file is available to test your program. Use Symbols, wherever
 possible.
=end

class Mp3File
    def initialize(filename)
        @filename = filename
        
        puts "Reading in #{@filename}"
        
        if (!File.exist?(@filename))
            puts "ERROR: File #{@filename} does not exist."
        end
        
        mp3_file = File.open(@filename, 'r')
        
        # SEEK_END - Seeks to first integer number parameter plus end of stream 
        mp3_file.seek(-128, IO::SEEK_END)
        inbuf = mp3_file.read(3)
        if (inbuf != "TAG")
            puts "Could not find TAG tag. File must not have ID3 tags"
        end
        
        @song   = mp3_file.read(30).rstrip!
        @artist = mp3_file.read(30).rstrip!
        @album = mp3_file.read(30).rstrip!
        @year = mp3_file.read(4)
        @other_tags = mp3_file.gets.strip!
        
        mp3_file.close
    end
    
    attr_reader :filename, :song, :artist, :album, :other_tags, :year
end

# class Mp3Reader
    # def initialize(filename)
        # @filename = filename
    # end
    # 
    # def read_id3
        # puts "Reading in #{@filename}"
        # 
        # if (!File.exist?(@filename))
            # "ERROR: File #{@filename} does not exist."
        # end
        # 
        # mp3_file = File.open(@filename, 'r')
        # 
        # # SEEK_END - Seeks to first integer number parameter plus end of stream 
        # mp3_file.seek(-128, IO::SEEK_END)
        # inbuf = mp3_file.read(3)
        # if (inbuf != "TAG")
            # "Could not find TAG tag. File must not have ID3 tags"
        # end
        # 
        # song   = mp3_file.read(30).rstrip!
        # artist = mp3_file.read(30).rstrip!
        # album = mp3_file.read(30).rstrip!
        # mp3_file.close
        # 
        # "#{song}, #{artist}, #{album}"
# 
    # end
    # 
    # def raw_id3
        # puts "Reading in #{@filename}"
        # 
        # if (!File.exist?(@filename))
            # "ERROR: File #{@filename} does not exist."
        # end
        # 
        # mp3_file = File.open(@filename, 'r')
        # 
        # # SEEK_END - Seeks to first integer number parameter plus end of stream 
        # mp3_file.seek(-128, IO::SEEK_END)
        # inbuf = mp3_file.gets
        # 
        # mp3_file.close
        # 
        # inbuf
    # end
# end

if (ARGV.size == 0)
    puts "Filename required."
    exit 1
end

file = Mp3File.new(ARGV[0])

printf "%-20s%-15s%-15s%-6s%-s\n","Song","Artist","Album","Year","Other tags"
printf "%-20s%-15s%-15s%-6s%-s\n",file.song,file.artist,file.album,file.year,file.other_tags
 
