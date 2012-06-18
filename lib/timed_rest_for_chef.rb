require 'timeout'
require 'chef/rest/rest_request'

if(Gem::Version.new(Chef::VERSION) < Gem::Version.new('10.14.0'))

  # Custom timeout class to make it easy to log
  # this specific type of timeout
  class RESTTimeout < Timeout::Error
  end

  module TimedRestForChef
    def timed_call
      begin
        Timeout::timeout(config[:rest_timeout], RESTTimeout) do
          puts '*' * 100
          puts "CALLING IN WRAP"
          original_call
        end
      rescue => e
        if(e.is_a?(WrapperTimeout))
          Chef::Log.warn "Maximum request timeout has been reached"
        end
        raise 
      end
    end

    def self.included(base)
      base.class_eval do
        alias_method :original_call, :call
        alias_method :call, :timed_call
      end
    end

  end
  Chef::REST::RESTRequest.send(:include, TimedRestForChef)
end
