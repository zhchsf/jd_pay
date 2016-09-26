module JdPay
  module Util
    # 京东支付 des3 加解密，掺杂了京东自定义的一些位转移逻辑
    class Des3
      def self.encrypt(source, base64_key)
        key = Base64.decode64(base64_key)
        transformed_source = transform_source(source.bytes)

        des = OpenSSL::Cipher::Cipher.new('des-ede3')
        des.encrypt
        des.key = key
        des.padding = 0
        res = des.update(transformed_source) + des.final
        res.unpack("H*").first
      end

      def self.decrypt(source, base64_key)
        key = Base64.decode64(base64_key)
        b2 = source.chars.each_slice(2).map{|x| x.join().to_i(16) }.map(&:chr).join

        des = OpenSSL::Cipher::Cipher.new('des-ede3')
        des.decrypt
        des.key = key
        des.padding = 0
        res = des.update(b2) + des.final
        decrypt_bytes = res.bytes

        bytes_length = bytes_to_int(decrypt_bytes[0, 4])
        decrypt_bytes[4, bytes_length].map(&:chr).join
      end

      # 对要加密的字符串按照京东的规则处理
      def self.transform_source(source_bytes)
        source_len = source_bytes.length
        x = (source_len + 4) % 8
        y = x == 0 ? 0 : 8 - x

        result_bytes = []
        0.upto(3).each do |index|
          result_bytes << ((source_len >> (3 - index) * 8) & 0xFF)
        end
        result_bytes += source_bytes
        y.times { result_bytes << 0 }

        result_bytes.map(&:chr).join
      end

      # 解密
      def self.bytes_to_int(bytes)
        total = 0
        bytes.each_with_index do |value, index|
          shift = (3 - index) * 8
          total += (value & 0xFF) << shift
        end
        total
      end
    end
  end
end
