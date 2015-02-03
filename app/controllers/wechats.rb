Sanna::App.controllers :wechats do
  require 'net/http'
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
    get :index,:map=>'/myaccepts' do
   if  Wechat.check_weixin_legality(params[:timestamp], params[:nonce],params[:signature])
 
   return render text:params[:echostr]
  
  else
     #验证失败
  end
  end
   #发送消息
post :process_request ,:map=>'/myaccepts' do
  if  Wechat.check_weixin_legality
      if params[:xml][:MsgType]=='event'
           if params[:xml][:Event]=='subscribe'
          render :xml 
          elsif  params[:xml][:Event]=='unsubscribe'
          render :xml
           elsif params[:xml][:Event]=='VIEW'
        
          end
       elsif params[:xml][:MsgType]=='text'
         render :xml
      end
  end

end

get :setmenu   do
       uri = URI(' https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{Lzh.get_access_token}')

Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Post.new uri
  request.set_form_data(Wechat.menu_to_json)
  response = http.request request # Net::HTTPResponse object
end
end

end
