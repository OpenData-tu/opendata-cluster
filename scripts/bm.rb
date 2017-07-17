#!/bin/ruby
require "time"
require 'open-uri'
require 'json'

# http://yourelasticsearch.com:9200/data-loadtest/_count


def get(url)
  open(url) do |f|
    page_string = f.read
  end
end

def get_count(url)
  JSON.parse(get(url))["count"].to_i
end


def run_bm(time_to_sleep,url)
  count_start = get_count(url)
  puts "Count start: #{count_start}" 

  sleep time_to_sleep

  count_end = get_count(url)
  puts "Count end: #{count_end}" 

  speed = count_end - count_start
  puts "Speed: #{speed} in #{time_to_sleep}s" 
  return speed
end

time_to_sleep = 10

url = ARGV[0]
tests = []
10.times do
  tests.push(run_bm(time_to_sleep,url))
end

def mean(arr,time_to_sleep)
  (arr.reduce(:+).to_f / arr.size)/time_to_sleep
end

puts
puts "#{mean(tests,time_to_sleep)}/s"
