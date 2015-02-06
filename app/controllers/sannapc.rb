Sanna::App.controllers :sannapc do
  
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
  get :index do
    puts 'ok'
    @shop=Shop.first
    @orders=@shop.orders.where(isnow:true)

    render :index
  end
  get :checknew do

    shop=Shop.find(params[:shop_id])
    upclock=shop.orders.where(isnow:true,usedate:(Time.now-1.second)..(Time.now)).first
    if upclock
      isupdate=true
     end
    orderids=params[:orderids].split(',')
     downclock=Order.where(:_id.in=>orderids).where(isnow:false).first
  if downclock
      isupdate=true
  end
if isupdate
  render :html,'true'
else
  render :html,'false'
end
 end

end
