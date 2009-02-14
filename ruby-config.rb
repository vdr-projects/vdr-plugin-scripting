require 'rbconfig'

if ARGV.include?('--cflags')
    if Config::CONFIG["rubyhdrdir"]
        rubyhdrdir = Config::CONFIG["rubyhdrdir"]
        arch = Config::CONFIG["arch"]
        puts "-I#{rubyhdrdir} -I#{rubyhdrdir}/#{arch}"
    else
        puts '-I' + Config::CONFIG["archdir"]
    end
end

if ARGV.include?('--libs')
    puts Config::CONFIG["LIBRUBYARG"] || "-l" + Config::CONFIG["ruby_install_name"]
end
