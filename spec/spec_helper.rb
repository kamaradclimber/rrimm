require 'rspec'
require_relative '../lib/rrimm'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow: 'www.example.org')
