#!/bin/ruby
require "time"


def get_count
  %x["./scripts/bm.sh"].to_i
end


def run_bm(time_to_sleep)
  count_start = get_count
  puts "Count start: #{count_start}" 

  sleep time_to_sleep

  count_end = get_count
  puts "Count end: #{count_end}" 

  speed = count_end - count_start
  puts "Speed: #{speed} in #{time_to_sleep}s" 
  return speed
end

tests = []
10.times do
  tests.push(run_bm(10))
end

def mean arr
  arr.reduce(:+).to_f / arr.size
end

puts
puts "#{mean tests}/10s"
