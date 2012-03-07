require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path("../command_helper", __FILE__)

describe "github pull-request" do
  include CommandHelper

  specify "pull-request should die with no args" do
    running :'pull-request' do
      setup_url_for
      @command.should_receive(:die).with("Specify a user for the pull request").and_return { raise "Died" }
      self.should raise_error(RuntimeError)
    end
  end

  specify "pull-request user should track user if untracked" do
    running :'pull-request', "user" do
      setup_url_for
      setup_remote :origin, :user => "kballard"
      setup_remote :defunkt
      @helper.should_receive(:get_first_commit_message).once
      GitHub.should_receive(:invoke).with(:track, "user").and_return { raise "Tracked" }
      self.should raise_error("Tracked")
    end
  end

  specify "pull-request user should notify if pull request already exists" do
    running :'pull-request', "user" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @helper.should_receive(:get_first_commit_message)
      @command.stub!(:sh).and_return("Error: A pull request already exists for user:branch")
      stdout.should == "Error: A pull request already exists for user:branch"
    end
  end

  specify "pull-request user should notify if pull request was successfull" do
    running :'pull-request', "user" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @helper.should_receive(:get_first_commit_message).once
      @command.should_receive(:sh).with("curl -F 'login=drnic' -F 'token=MY_GITHUB_TOKEN' -F \"pull[base]=master\" -F \"pull[head]=user:branch\" -F \"pull[title]=Commit\" -F \"pull[body]=Commit\" https://github.com/api/v2/json/pulls/user/github-gem")
      stdout.should == "Successfully created pull request #1: Commit\nPull Request URL: https://github.com/user/github-gem/pulls/1\n"
    end
  end

  specify "pull-request user should generate a pull request" do
    running :'pull-request', "user" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @helper.should_receive(:get_first_commit_message).once
      @command.should_receive(:sh).with("curl -F 'login=drnic' -F 'token=MY_GITHUB_TOKEN' -F \"pull[base]=master\" -F \"pull[head]=user:branch\" -F \"pull[title]=Commit\" -F \"pull[body]=Commit\" https://github.com/api/v2/json/pulls/user/github-gem")
    end
  end

  specify "pull-request user/branch should generate a pull request" do
    running :'pull-request', "user/branch" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @helper.should_receive(:get_first_commit_message).once
      @command.should_receive(:sh).with("curl -F 'login=drnic' -F 'token=MY_GITHUB_TOKEN' -F \"pull[base]=branch\" -F \"pull[head]=user:branch\" -F \"pull[title]=Commit\" -F \"pull[body]=Commit\" https://github.com/api/v2/json/pulls/user/github-gem")
    end
  end

  specify "pull-request user should generate a pull request with branch master" do
    running :'pull-request', "user" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @helper.should_receive(:get_first_commit_message).once
      @command.should_receive(:sh).with("curl -F 'login=drnic' -F 'token=MY_GITHUB_TOKEN' -F \"pull[base]=master\" -F \"pull[head]=user:branch\" -F \"pull[title]=Commit\" -F \"pull[body]=Commit\" https://github.com/api/v2/json/pulls/user/github-gem")
    end
  end

  specify "pull-request user branch should generate a pull request" do
    running:'pull-request', "user", "branch" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @helper.should_receive(:get_first_commit_message).once
      @command.should_receive(:sh).with("curl -F 'login=drnic' -F 'token=MY_GITHUB_TOKEN' -F \"pull[base]=branch\" -F \"pull[head]=user:branch\" -F \"pull[title]=Commit\" -F \"pull[body]=Commit\" https://github.com/api/v2/json/pulls/user/github-gem")
    end
  end

  specify "pull-request user branch title should generate a pull request with a custom title" do
    running:'pull-request', "user", "branch", "title" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @command.should_receive(:sh).with("curl -F 'login=drnic' -F 'token=MY_GITHUB_TOKEN' -F \"pull[base]=branch\" -F \"pull[head]=user:branch\" -F \"pull[title]=title\" -F \"pull[body]=title\" https://github.com/api/v2/json/pulls/user/github-gem")
    end
  end

  specify "pull-request user branch title should generate a pull request with a custom title and comment" do
    running:'pull-request', "user", "branch", "title", "comment" do
      setup_github_token
      setup_url_for "origin", "user", "github-gem"
      setup_remote "origin", :user => "user", :project => "github-gem"
      setup_user_and_branch "user", "branch"
      @command.should_receive(:sh).with("curl -F 'login=drnic' -F 'token=MY_GITHUB_TOKEN' -F \"pull[base]=branch\" -F \"pull[head]=user:branch\" -F \"pull[title]=title\" -F \"pull[body]=comment\" https://github.com/api/v2/json/pulls/user/github-gem")
    end
  end
end
