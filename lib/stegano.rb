
module Stegano
  extend self

  def embed_text(pixels, text)
    bits = text.unpack("B*").first.scan(/../).to_a

    abort "Image is too small." if pixels.size < bits.size

    bits.size.times do |i|
      x = pixels[i].unpack("B*")

      x[0][-2..-1] = bits[i]

      pixels[i] = x.pack("B*")
    end

    pixels
  end

  def recover_text(pixels)
    bits = []

    pixels.size.times do |i|
      x = pixels[i].unpack("B*")
      bits << x[0][-2..-1]
    end

    p Array(bits.join).pack("B*")
  end
end
