require 'spec_helper'
require 'katapult/util'

describe Katapult::Util do

  describe '#git_commit' do
    it 'adds all files before committing' do
      allow(Katapult::Util).to receive(:system).with(/git add --all; git commit/)
      Katapult::Util.git_commit 'test'
    end

    it 'sets "katapult" as commit author' do
      allow(Katapult::Util).to receive(:system).with(/git commit.*--author='katapult \<katapult@makandra\.com\>'/)
      Katapult::Util.git_commit 'test'
    end

    it 'sanitizes the commit message' do
      allow(Katapult::Util).to receive(:system).with(/git commit -m '"hack0r"'/)
      Katapult::Util.git_commit "\"hack''''0r\""
    end
  end

end
