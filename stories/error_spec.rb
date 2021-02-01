require 'stories/story_helper'

describe "Error handling" do
  Given(:output_directory) { "tmp" }
  Given(:input_file_name)  { "stories/errors.in" }
  Given(:answer_file_name) { "stories/errors.ans" }
  Given(:output_file_name) { "#{output_directory}/errors.out" }

  Given { FileUtils.mkdir_p output_directory rescue nil }
  Given(:output) { contents_of(output_file_name) }
  When(:result) { system "ruby -Ilib bin/ocr <#{input_file_name} >#{output_file_name}" }

  Then { expect(result).to be false }
  And  { expect(output).to match /error detected/i }
  And  { expect(output).to match /line 9/i }
  And  { expect(output).to match /this is a bad input/i }
end
