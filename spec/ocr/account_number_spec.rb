require 'spec_helper'

module OCR

  describe AccountNumber do
    Given(:digits) { nil }
    Given(:lines) { nil }
    Given(:acct) {
      digits ? AccountNumber.from_digits(digits) : AccountNumber.new(lines)
    }

    context "with valid legible digits" do
      Given(:digits) { "345882865" }
      Then { expect(acct).to be_valid }
      Then { expect(acct).to be_legible }
      Then { expect(acct.show).to eq digits }
    end

    context "with illegible digits and no valid alternatives" do
      Given(:lines) { [
        "    _  _  _  _  _  _      |",
        "|_||_|| || ||_   |  |  |  |",
        "  | _||_||_||_|  |  |  |  |" ]
      }
      Then { expect(acct).to_not be_valid }
      Then { expect(acct).to_not be_legible }
      Then { expect(acct.show).to eq "49006771? ILL" }
    end

    context "with illegible digits and one valid alternative" do
      Given(:lines) { [
        " _     _  _  _     _  _  _ ",
        " _||_||_ |_||_| _||_||_ |_ ",
        " _|  | _||_||_||_ |_||_| _|" ]
      }
      Then { expect(acct).to_not be_valid }
      Then { expect(acct).to_not be_legible }
      Then { expect(acct.show).to eq "345882865" }
    end

    context "with illegible digits and multiple valid alternative" do
      # I don't think there is a test case for this combination.
      #
      # Since we constrain the alternatives to be single stroke
      # difference, we would have to find an illegible pattern that is
      # only one stroke away from two different digits that both
      # satisfy the checksum.  That seems impossible.
    end

    context "with invalid digits and no valid alternatives" do
      Given(:digits) { "030033001" }
      Then { expect(acct).to_not be_valid }
      Then { expect(acct).to be_legible }
      Then { expect(acct.show).to eq "#{digits} ERR" }
    end

    context "with invalid digits and a single valid alternative" do
      Given(:digits) { "111111111" }
      When(:alts) { acct.valid_alternatives }
      Then { expect(alts).to eq [ "711111111" ] }
      Then { expect(acct).not_to be_valid }
      Then { expect(acct).to be_legible }
      Then { expect(acct.show).to eq "711111111" }
    end

    context "with invalid digits and multiple alternatives" do
      Given(:digits) { "345862865" }
      When(:alts) { acct.valid_alternatives }
      Then { expect(alts).to eq ['345662865', '345882865', '945862865'] }
      Then { expect(acct).to_not be_valid }
      Then { expect(acct).to be_legible }
      Then { expect(acct.show).to eq "345862865 AMB ['345662865', '345882865', '945862865']" }
    end

    context "with too few digits" do
      Given(:digits) { "00000000" }
      Then { expect(acct).to_not be_valid }
      Then { expect(acct).to be_legible }
      Then { expect(acct.show).to eq "#{digits} ERR" }
    end

    context "with too many digits" do
      Given(:digits) { "0000000000" }
      Then { expect(acct).to_not be_valid }
      Then { expect(acct).to be_legible }
      Then { expect(acct.show).to eq "#{digits} ERR" }
    end
  end

end

