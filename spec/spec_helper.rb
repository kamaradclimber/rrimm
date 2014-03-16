require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'coveralls'
Coveralls.wear!

SimpleCov.minimum_coverage 95
SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

require 'rspec'
require_relative '../lib/rrimm'
