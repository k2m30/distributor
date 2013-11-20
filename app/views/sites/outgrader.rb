require 'rubygems'
require 'mechanize'
require 'benchmark'

sites = ['http://tut.by', 'http://onliner.by', 'http://google.by','http://stackoverflow.com/questions/6381615/measure-user-time-or-system-time-in-ruby-without-benchmark-or-time',
         'http://rubylearning.com/blog/2013/06/19/how-do-i-benchmark-ruby-code/', 'https://github.com/acangiano/ruby-benchmark-suite', 'http://www.ruby-doc.org/stdlib-1.9.3/libdoc/benchmark/rdoc/Benchmark.html',
         'http://kinozal.tv/top.php', 'http://lurkmore.to/Копипаста:Uncle_Anon', 'http://gmail.com']

p sites.size
n = 10
delay = 2000

agent = Mechanize.new
measure = Benchmark.measure do
  n.times do
    sites.each do |site|
      page = agent.get(site)
    end
  end
end
puts measure

agent_proxy = Mechanize.new
agent_proxy.set_proxy '192.168.12.46', 8888
measure =  Benchmark.measure do
  n.times do
    sites.each do |site|
      page = agent.get(site)
    end
  end
end
puts measure
