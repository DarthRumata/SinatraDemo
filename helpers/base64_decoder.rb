module Decoder

  class Base64Decoder
    def self.decode(str)
      encoded = str.split(',')[1]
      Base64.decode64(encoded)
    end
  end

end