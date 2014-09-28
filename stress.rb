#
# Ruby-based PC Stability Tester (stress CPU || RAM).
#
# Licensed under GNU/GPLv3.
#

mode = ARGV[0]

if !mode || (mode != "1" && mode != "2")
	puts "\n PC stability tester"
	puts "\n | Usage |"
	puts "  ruby pc_test.rb 1    [To stress CPU]"
	puts "  ruby pc_test.rb 2    [To stress RAM]\n\n"
else
	if mode == "1"
		puts "\n Testing CPU ..."
		var = 0
		9.times do
			Thread.new do
				loop do
					var += 1
				end
			end
		end
		loop do
			var += 1
		end
	else
		def fuck()
			loop do
				Thread.new do
					fuck()
				end
			end
		end
		puts "\n Testing RAM ..."
		fuck()
	end
end
