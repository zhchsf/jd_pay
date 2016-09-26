describe "util des3" do
  before do
    @base64_key = "2BJuklQ0LoURFkIh1nlJvyMsO+leGIDe\n"
  end

  describe "#encrypt" do
    shared_examples "des3 encrypt compare" do |encrypt_str, expect_encrypted_str|
      it "#{encrypt_str} expect encrypt to #{expect_encrypted_str}" do
        result = JdPay::Util::Des3.encrypt(encrypt_str, @base64_key)
        expect(result).to eq expect_encrypted_str
      end
    end

    [['abcdefg', '6294fde48a0054efc6f9f19b3c31b8dd']].each do |encrypt_str, expect_encrypted_str|
      it_behaves_like "des3 encrypt compare", encrypt_str, expect_encrypted_str
    end
  end

  describe "#encrypt" do
    shared_examples "jd decrypt compare" do |decrypt_str, expect_decrypted_str|
      it "#{decrypt_str} expect decrypt to #{expect_decrypted_str}" do
        result = JdPay::Util::Des3.decrypt(decrypt_str, @base64_key)
        expect(result).to eq expect_decrypted_str
      end
    end

    [['6294fde48a0054efc6f9f19b3c31b8dd', 'abcdefg']].each do |decrypt_str, expect_decrypted_str|
      it_behaves_like "jd decrypt compare", decrypt_str, expect_decrypted_str
    end
  end
end
