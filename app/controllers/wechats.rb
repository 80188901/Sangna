Sanna::App.controllers :wechats do
  require 'net/http'
  require "rexml/document"
  
disable :protect_from_csrf
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
    get :index,:map=>'/wechats' do
   if  Wechat.check_weixin_legality(params[:timestamp], params[:nonce],params[:signature])
 
   return render :html,params[:echostr]
  
  else
     #验证失败
  end
  end

get :mytest do
  uri=URI("http://sangna.29mins.com/wechats")
  Net::HTTP.start(uri.host, uri.port) do |http|
 request= Net::HTTP::Post.new uri
 request.body=' <xml><ToUserName><![CDATA[toUser]]></ToUserName><FromUserName><![CDATA[fromUser]]></FromUserName><CreateTime>1348831860</CreateTime><MsgType><![CDATA[image]]></MsgType><PicUrl><![CDATA[this is a url]]></PicUrl><MediaId><![CDATA[media_id]]></MediaId><MsgId>1234567890123456</MsgId></xml>'
 response=http.request request
puts response.body
end
end


   #发送消息
post :process_request ,:map=>'/wechats' do

if  Wechat.check_weixin_legality(params[:timestamp], params[:nonce],params[:signature])
     doc = REXML::Document.new request.body
     @root=doc.root
     puts 'aa'
     puts @root.class
     xml=@root.get_elements("MsgType")[0][0]
     puts 'bb'
     puts xml
  if @root.get_elements['MsgType'][0][0]=='event'
    if @root.get_elements['Event'][0][0]=='subscribe'
       render "/wechats/process_request"
     elsif @root.get_elements['Event'][0][0]=='unsubscribe'
       render "/wechats/process_request"
     end
   elsif @root.get_elements['MsgType'][0][0]=='text'
    render "/wechats/response_msg"
  end
 end
end
=begin
get :process_request do
  render "/wechats/process_request"
end

get :mytest do
     render :mytest
end
=end
get :setmenu   do
  tok=Wechat.get_access_token
  puts tok
 uri = URI("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{tok}"  )

Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Post.new(uri,{'Content-Type' => 'application/json'})
 #request.set_form_data(Wechat.menu_to_json)
 request.body=Wechat.menu_to_json
    response = http.request(request) 
    puts 'aa'
    puts response.body
end
redirect(url(:home,:nearby))
end

get :deletemenu do
   tok=Wechat.get_access_token
  puts tok
 uri = URI("https://api.weixin.qq.com/cgi-bin/menu/delete?access_token=#{tok}")
Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request=Net::HTTP::Get.new uri
  response=http.request(request)
  puts response.body
end
end
end