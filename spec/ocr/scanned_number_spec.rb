require 'spec_helper'

module OCR

  describe ScannedNumber do

    context "when well formed" do
      Given(:number) { ScannedNumber.new(lines) }
      Invariant { expect(number).to be_legible }
      Invariant { expect(number).not_to be_illegible }
      Invariant { expect(number.scanned_lines).to eq lines }

      context "with a single numeral" do
        Given(:lines) {
          [ "   ",
            "  |",
            "  |" ]
        }
        Then { expect(number.value).to eq "1" }
        Then { expect(number.scanned_chars).to eq [lines.join] }
      end

      context "with different single numeral" do
        Given(:lines) {
          [ " _ ",
            " _|",
            " _|" ]
        }
        Then { expect(number.value).to eq "3" }
        Then { expect(number.scanned_chars).to eq [lines.join] }
      end

      context "with multiple numerals" do
        Given(:lines) {
          [ "    _ ",
            "  | _|",
            "  | _|" ]
        }
        Then { expect(number.value).to eq "13" }
        Then { expect(number.scanned_chars).to eq ["     |  |", " _  _| _|"] }
      end

      context "with all the numerals" do
        Given(:lines) {
          [ " _     _  _     _  _  _  _  _ ",
            "| |  | _| _||_||_ |_   ||_||_|",
            "|_|  ||_  _|  | _||_|  ||_| _|",
          ]
        }
        Then { expect(number.value).to eq "0123456789" }
      end
    end

    context "with an unrecognized digit" do
      Given(:lines) {
        [ "    _  _ ",
          "  | _  _|",
          "  ||_  _|" ]
      }
      When(:number) { ScannedNumber.new(lines) }
      Then { expect(number.value).to eq "1?3" }
      And  { number.should be_illegible }
      And  { number.should_not be_legible }
    end

    describe "illformed numbers" do
      When(:result) { ScannedNumber.new(lines) }

      context "with illegal characters" do
        Given(:lines) {
          [ "    _  _ ",
            "  | _| _|",
            "  ||_ x_|" ]
        }
        Then { result.should have_failed(IllformedScannedNumberError, /illegal character/i)  }
      end

      context "with lines lengths not divisible by 3" do
        Given(:lines) {
          [ "    _  _  ",
            "  | _| _| ",
            "  ||_  _| " ]
        }
        Then { result.should have_failed(IllformedScannedNumberError, /length.*(3|three)/i)  }
      end

      context "with missing lines" do
        Given(:lines) {
          [ "    _  _ ",
            "  | _| _|" ]
        }
        Then { result.should have_failed(IllformedScannedNumberError, /(3|three) lines/i)  }
      end
    end

    describe "creating numbers from digit strings" do
      When(:number) { ScannedNumber.from_digits(digits) }

      context "with legible chars" do
        Given(:digits) { "0123456789" }
        Then { expect(number.value).to eq digits }
        Then { expect(number.show).to eq digits }
      end

      context "with illegible chars" do
        Given(:digits) { "01234?6789" }
        Then { expect(number.value).to eq digits }
        Then { expect(number.show).to eq digits }
      end
    end

    describe "#scanned_chars" do
      Given(:lines) {
        [ "    _ ",
          "  | _|",
          "  | _|" ]
      }
      Given(:number) { ScannedNumber.new(lines) }
      When(:result) { number.scanned_chars }
      Then { expect(result).to eq ["     |  |", " _  _| _|"] }
    end

    describe "#alternatives" do
      context "with legible input" do
        Given(:lines) {
          [ "                           ",
            "  |  |  |  |  |  |  |  |  |",
            "  |  |  |  |  |  |  |  |  |" ]
        }
        Given(:number) { ScannedNumber.new(lines) }
        When(:result) { number.alternatives }
        Then { expect(result).to eq [
          "711111111",
          "171111111",
          "117111111",
          "111711111",
          "111171111",
          "111117111",
          "111111711",
          "111111171",
          "111111117",
        ] }
      end

      context "with illegible input" do
        Given(:lines) {
          [ "                          |",
            "  |  |  |  |  |  |  |  |  |",
            "  |  |  |  |  |  |  |  |  |" ]
        }
        Given(:number) { ScannedNumber.new(lines) }
        When(:result) { number.alternatives }
        Then { expect(result).to eq [ "111111111" ] }
      end
    end

  end

end
