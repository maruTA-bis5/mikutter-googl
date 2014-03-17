# -*- coding: utf-8 -*-
require 'net/https'

class GooGl < MessageConverters

  def plugin_name() 
    :googl
  end

  def shrink_url(url) 
    # not impl.
    return url
  end

  def shrinked_url?(url)
    url.is_a? String and Regexp.new('\Ahttp://goo\\.gl/') === url
  end
	
  APIKEY = 'AIzaSyDVxHh8nADmKQweHAP9mxKrdmYRZCBnjjs'

  def expand_url(url) 
    return nil unless shrinked_url? url
    url.freeze
    notice url
    https = Net::HTTP.new('www.googleapis.com', 443)
    https.use_ssl = true
    https.start {
      response = begin
                  JSON.parse(https.get('/urlshortener/v1/url?shortUrl=#{url}&key=#{APIKEY}'))
                 rescue Exception
                   nil end
      if response and response['status_code'].to_i == 200
        return response['longUrl'] end
    }
    nil
  end

  regist

end
