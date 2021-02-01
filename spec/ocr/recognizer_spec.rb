require 'spec_helper'

module OCR

  describe Recognizer do
    Given(:recog) { RECOGNIZER }
    Then { expect(recog).not_to be_nil }

    describe "recognizing" do
      Recognizer::SCANNABLE_CHARS.each.with_index do |sc, i|
        context "a scanned character '#{sc}'" do
          Then { expect(recog.recognize(sc)).to eq i.to_s }
        end
      end

      context "an invalid scanned character" do
        Given(:scanned_char) { "  |  |  |" }
        Then { expect(recog.recognize(scanned_char)).to eq '?' }
      end
    end

    describe "guessing" do
      context "with no confidence limits" do
        Given(:scanned_char) {  "  |  |  |" }
        Given(:expected_guesses) {
          Recognizer::SCANNABLE_CHARS.map { |c| Recognizer::Guess.new(scanned_char, c) }.sort
        }

        When(:result) { recog.guess(scanned_char) }

        Then { expect(result).to eq expected_guesses }
      end

      context "with a confidence level of 1" do
        context "when the scan is ambiguous" do
          Given(:scanned_char) {  "  |  |  |" }
          Given(:expected_guesses) { [ Recognizer::Guess.new(scanned_char, "     |  |") ] }

          When(:result) { recog.guess(scanned_char, 1) }

          Then { expect(result).to eq expected_guesses }
        end

        context "when the scan is not ambiguous" do
          Given(:scanned_char) {  "     |  |" }
          Given(:expected_guesses) { [ Recognizer::Guess.new(scanned_char, " _   |  |") ] }

          When(:result) { recog.guess(scanned_char, 1) }

          Then { expect(result).to eq expected_guesses }
        end
      end
    end

  end

end
