#!/usr/bin/env ruby

puts File.expand_path("../../lib", __FILE__)
$: << File.expand_path("../../lib", __FILE__)
require 'rubygems'
require 'hoodwinkd'
require 'rack/adapter/camping'

Hoodwinkd.connect File.expand_path('../../config/database.yml', __FILE__)
Hoodwinkd.create

app = Rack::Builder.new {
  use Rack::CommonLogger
  use Rack::ShowExceptions
  map "/" do
    use Rack::Lint
    run Rack::Adapter::Camping.new(Hoodwinkd)
  end
  map "/s/" do 
    use Rack::CommonLogger
    use Rack::ShowExceptions
    run Rack::Directory.new("../../static")
  end
}

run app