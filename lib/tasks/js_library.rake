desc 'Create /lib/dist/factlink_loader.min.js'
task 'assets:precompile' do
  fingerprint = /\-[0-9a-f]{32}\./

  for original_filename in Dir['public/lib/dist/factlink_loader.min*.js']
    next unless original_filename =~ fingerprint

    copy_filename = original_filename.sub(fingerprint, '.')
    FileUtils.cp original_filename, copy_filename, verbose: true
  end
end
