Sanna::App.controllers :orders do
  
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
  
get :create do
  puts 'aaaa'
   @order=Order.create!(shop_id:params[:shop_id],server_id:params[:server_id],applydate:Time.now,remark:'i want girls')
    render :html,'/home/myorders?shop_id='+params[:shop_id]
end
end
