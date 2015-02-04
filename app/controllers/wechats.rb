Sanna::App.controllers :wechats do
  require 'net/http'
 use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end

end 
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
 request.body
 response=http.request request
end
end


   #发送消息
post :process_request ,:map=>'/wechats', :csrf_protection =>false do
  if  Wechat.check_weixin_legality(params[:timestamp], params[:nonce],params[:signature])
      if params[:xml][:MsgType]=='event'
           if params[:xml][:Event]=='subscribe' 
               render "/wechats/process_request"
         elsif  params[:xml][:Event]=='unsubscribe'
         render "/wechats/process_request"
         end
       elsif params[:xml][:MsgType]=='text'
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