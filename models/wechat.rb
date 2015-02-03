class Wechat
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
 @weixin_token="tiandiwang"
  # field <name>, :type => <type>, :default => <value>
  

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
  def  self.check_weixin_legality(timestamp,nonce,signature)
  array = [@weixin_token, timestamp, nonce].sort
  if signature != Digest::SHA1.hexdigest(array.join)
    return true
  else
    return false
  end
end
def  self.event_view(eventkey)
  
end

def  self.get_access_token
    uri = URI('https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxqufghje913scgsjr&secret=xlw5q31w92uejipg7tcylbhpexrsroak')

Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Get.new uri

  response = http.request request 
  response_json=JSON.parse(response.options[:response_body])  
  return response_json["access_token"]  
end
end

def  self.menu_to_json
      str=" {'button':[ { 'type':'view', 'name':'huisuo',  'url':'V1001_TODAY_MUSIC' },  {'type':'view', 'name':'jishi', 'url':'V1001_TODAY_MUSIC'  }, {'type':'view', 'name':'wode', 'url':'V1001_TODAY_MUSIC'}]}"
      return str.to_json
  end
end
