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
    return false
  else
    return true
  end
end


def  self.get_access_token

 uri = URI('https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx697eed6c8f1d5c78&secret=4ca9075efe702387bd92d6f2ce1fafe2')

Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Get.new uri

  response = http.request request 

  response_json=JSON.parse(response.body)  

  return response_json["access_token"]  
end
end

def  self.menu_to_json
      str='{"button": [{"name":"会所","sub_button":[{"type":"view","name":"附近会所","url":'+
      '"http://sangna.29mins.com"}]},{"type":"click","name":"我的","key":"my"},{"type":"view","name":"技师","url":'+
        '"http://sangna.29mins.com/jishi/showlogin"}]}'
        puts str

      return str
  end
end
