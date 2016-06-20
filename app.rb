require 'bindata'
require 'pp'

require_relative 'lib/png-header'
require_relative 'lib/chunk'

abort "Please provide a file name." unless ARGV[0]

f = File.open(ARGV[0])
pp header = PNG_Image.read(f)

chunks = []

loop { chunks << Chunk.read(f); pp chunks.last; break if chunks.last.chunk_type == 1229278788 }
