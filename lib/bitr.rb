require 'rubygems'
require 'rack'
require 'json'
require 'uuidtools'

module BitR

  class Request < Rack::Request

    def handle
      if self.get?
        uuid = self.path[1..-1]

        headers = Hash.new.tap do |h|
          h["content-type"] = 'text/html'
          h["location"] = @@urls[uuid] if @@urls[uuid]
        end

        return [302, headers, [''] ] if @@urls[uuid]

        binding.pry
        return [200, {"Content-Type" => "text/html"}, ['Unrecognized url']]
      end

      if self.post?
        uuid = UUIDTools::UUID.timestamp_create.to_s

        return [400, {"Content-Type" => "application/json"},
          [{:success => false, :error => "No :url passed for tracking"}.to_json]
        ] if (!self.params or !self.params.keys.include? 'url')

        url = self.params['url']
        @@urls[uuid] = url
        puts "Added #{uuid} => #{url}"
        return [200, {"Content-Type" => "application/json"},
          [{:success => true, :url => "http://#{self.env['HTTP_HOST']}/#{uuid}"}.to_json]
        ]
      end
    end

  end

  class Server

    def call env
      request = Request.new env
      request.handle
    end

  end

end
