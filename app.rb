require 'bindata'
require 'pp'

require_relative 'lib/chunk'
require_relative 'lib/png-header'
require_relative 'lib/compressor'
require_relative 'lib/filter_remover'

ARGV[0] = "/home/matu/Desktop/test-image.png"

abort "Please provide a file name." unless ARGV[0]

f = File.open(ARGV[0])
pp header = PNG_Image.read(f)

chunks = []

loop { chunks << Chunk.read(f); pp chunks.last; break if chunks.last.chunk_type == 1229278788 }

image_data = Compressor.inflate(chunks)
pixels     = FilterRemover.unfilter(image_data, header)
# Stegano class
image_data = FilterAdder.filter(pixels)
compressed = Compressor.deflate(image_data)

generate_image(header, compressed)
