require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "github help" do
  it "should output help contents" do
    example_output = File.expand_path(File.dirname(__FILE__) + "/../resources/help_output.txt")
    executable = File.expand_path(File.dirname(__FILE__) + '/../../bin/github')
    
    io = IO.popen(executable)
    out = io.read rescue ''
    io.close
    
    (File.read(example_output).to_s + "\n").should == out
  end
end
