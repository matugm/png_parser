require 'bindata'
require 'pp'

require_relative 'lib/chunk'
require_relative 'lib/png-header'
require_relative 'lib/compressor'
require_relative 'lib/filter_remover'
require_relative 'lib/filter_adder'
require_relative 'lib/image_generator'


if !ARGV[0]
  file_name = "#{__dir__}/img/original.png"
else
  file_name = ARGV[0]
end

file      = File.open(file_name)
pp header = PNG_Image.read(file)

chunks = []

loop { chunks << Chunk.read(file); pp chunks.last; break if chunks.last.chunk_type == 1229278788 }

image_data = Compressor.inflate(chunks)
pixels     = FilterRemover.unfilter(image_data, header)

# Stegano class

image_data = FilterAdder.filter(pixels, header)
compressed = Compressor.deflate(image_data)

ImageGenerator.generate(header, compressed)
