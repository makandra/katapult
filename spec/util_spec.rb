require 'katapult/binary_util'

describe Katapult::BinaryUtil do

  describe '#git_commit' do
    it 'adds all files before committing' do
      allow(Katapult::BinaryUtil).to receive(:system).with(/git add --all; git commit/)
      Katapult::BinaryUtil.git_commit 'test'
    end

    it 'sets "katapult" as commit author' do
      allow(Katapult::BinaryUtil).to receive(:system).with(/git commit.*--author='katapult \<katapult@makandra\.com\>'/)
      Katapult::BinaryUtil.git_commit 'test'
    end

    it 'sanitizes the commit message' do
      allow(Katapult::BinaryUtil).to receive(:system).with(/git commit -m '"hack0r"'/)
      Katapult::BinaryUtil.git_commit "\"hack''''0r\""
    end
  end

end
