module JdPay
  module Util
    # 京东支付 des3 加密，掺杂了京东自定义的一些位转移逻辑
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

      # 对要加密的字符串按照京东的规则处理
      def self.transform_source(source_bytes)
        source_len = source_bytes.length
        x = (source_len + 4) % 8
        y = x == 0 ? 0 : 8 - x

        result_bytes = []
        result_bytes << (source_len >> 24 & 0xFF)
        result_bytes << (source_len >> 16 & 0xFF)
        result_bytes << (source_len >> 8 & 0xFF)
        result_bytes << (source_len & 0xFF)
        result_bytes += source_bytes
        y.times { result_bytes << 0 }

        result_bytes.map(&:chr).join
      end
    end
  end
end
