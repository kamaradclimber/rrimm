require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'coveralls'
Coveralls.wear!

SimpleCov.minimum_coverage 90

require 'rspec'
require_relative '../lib/rrimm'
