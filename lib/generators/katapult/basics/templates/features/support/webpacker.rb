module WebpackerHelper

  module_function def compile_once
    digest_file = Rails.root.join("tmp/webpacker_#{Rails.env}_digest")

    packable_contents = Dir[Webpacker.config.source_path.join('**/*')]
      .sort
      .map { |filename| File.read(filename) if File.file?(filename) }
      .join
    digest = Digest::SHA256.hexdigest(packable_contents)

    return if digest_file.exist? && digest_file.read == digest

    # Base process compiles
    if ENV['TEST_ENV_NUMBER'].to_i < 1
      output_path = Webpacker.config.public_output_path
      FileUtils.rm_r(output_path) if File.exist?(output_path)
      puts "Removed Webpack output directory #{output_path}"

      Webpacker.compile or raise 'Compilation failed'

      digest_file.write(digest)

    # Parallel processes wait for compilation
    else
      loop do
        break if digest_file.exist? && digest_file.read == digest
        sleep 0.1
      end
    end
  end

end

WebpackerHelper.compile_once
