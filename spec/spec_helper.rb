require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'coveralls'
Coveralls.wear!

require 'rspec'
require_relative '../lib/rrimm'
