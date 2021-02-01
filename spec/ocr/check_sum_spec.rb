require 'spec_helper'

module OCR

  describe CheckSum do
    Given(:checker) { CHECKER }

    describe "#checksum" do
      Then { expect(checker.check_sum("000000000")).to eq 0 }
      Then { expect(checker.check_sum("777777777")).to eq 7 }
      Then { expect(checker.check_sum("123456789")).to eq 0 }

      Then { expect(checker.check_sum("000000002")).to eq (2 * 1) % 11 }
      Then { expect(checker.check_sum("000000020")).to eq (2 * 2) % 11 }
      Then { expect(checker.check_sum("000000200")).to eq (2 * 3) % 11 }
      Then { expect(checker.check_sum("000002000")).to eq (2 * 4) % 11 }
      Then { expect(checker.check_sum("000020000")).to eq (2 * 5) % 11 }
      Then { expect(checker.check_sum("000200000")).to eq (2 * 6) % 11 }
      Then { expect(checker.check_sum("002000000")).to eq (2 * 7) % 11 }
      Then { expect(checker.check_sum("020000000")).to eq (2 * 8) % 11 }
      Then { expect(checker.check_sum("200000000")).to eq (2 * 9) % 11 }
    end

    describe "#check?" do
      context "when the account number is good" do
        # good account numbers were taken from the user story specs
        Then { expect(checker.check?("000000000")).to be true }
        Then { expect(checker.check?("000000051")).to be true }
        Then { expect(checker.check?("123456789")).to be true }
        Then { expect(checker.check?("200800000")).to be true }
        Then { expect(checker.check?("333393333")).to be true }
        Then { expect(checker.check?("490867715")).to be true }
        Then { expect(checker.check?("664371485")).to be true }
        Then { expect(checker.check?("711111111")).to be true }
        Then { expect(checker.check?("777777177")).to be true }
      end

      context "when the account number is bad" do
        # bad account numbers were taken from the user story specs
        Then { expect(checker.check?("111111111")).not_to be true }
        Then { expect(checker.check?("490067715")).not_to be true }
        Then { expect(checker.check?("664371495")).not_to be true }
        Then { expect(checker.check?("00000000")).not_to be true }
        Then { expect(checker.check?("0000000000")).not_to be true }
      end
    end
  end

end

