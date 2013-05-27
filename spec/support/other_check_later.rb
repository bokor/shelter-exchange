# JSON and JSONP Testing
#module MockServerHelper

  ## These two functions should get put the support folder
  #def start_mock_server(port, &app)
    #server = Puma::Server.new app
    #server.add_tcp_listener '127.0.0.1', port
    #server.run
    #server
  #end

  ## stolen from capybara
  #def find_available_port
    #server = TCPServer.new('127.0.0.1', 0)
    #server.addr[1]
  #ensure
    #server.close if server
  #end
#end

# CarrierWave
# CarrierWave.configure do |config|
  #config.storage = :file
#end


# Artifice Helper
#module ArtificeHelper

  #def responder options={}

    #options = {
      #:status  => 200,
      #:body    => '',
      #:headers => {
        #'Content-Type' => 'application/json'
      #}
    #}.merge! options

    #lambda { |env|
      #[ options[:status], options[:headers], options[:body] ]
    #}
  #end

  #def with_standard_responses
    #Artifice.activate_with @standard_responder do
      #yield
    #end
  #end

  #def with_bad_domain
    #Artifice.deactivate # <-- Need to remove artifice to stub Net::HTTP directly

    #[ Net::HTTP, Mechanize ].each do |klass|
      #klass.class_eval do
        #alias :old_get :get
        #def get *args
          #raise SocketError.new 'getaddrinfo: nodename nor servname provided, or not known'
        #end
      #end
    #end

    #yield

    #[ Net::HTTP, Mechanize ].each do |klass|
      #klass.class_eval do
        #alias :get :old_get
      #end
    #end
  #end

  #def caught_requests= value
    #@caught_requests = value
  #end

  #def caught_requests
    #@caught_requests ||= []
  #end

  #def clear_caught_requests!
    #@caught_requests = []
  #end
#end

# these are needed or else capybara does not work nicely with artifice
#module Selenium
  #Net = ::Net.dup
  #module Net
    #silence_warnings do
      #HTTP = Artifice::NET_HTTP
    #end
  #end
#end

#class Capybara::Server
  #Net = ::Net.dup
  #module Net
    #silence_warnings do
      #HTTP = Artifice::NET_HTTP
    #end
  #end
#end

