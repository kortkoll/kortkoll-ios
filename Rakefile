task :cocoapods do
	puts "Install Cocoapods dependencies..."
  `pod install`
end

task :setup => :cocoapods do
  puts "Copying sample KKAppPrivate.m into place..."
  `cp Kortkoll/KKAppPrivateSample.m Kortkoll/KKAppPrivate.m`

  puts "Done! You're ready to get started!"
end
