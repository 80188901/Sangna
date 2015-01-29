Sanna::App.controllers :home do
  
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
  get :nearby  do
    @shops=Shop.all();

   render :nearby
end
get :lookdetails ,:with=>:id do
  @shop=Shop.find(params[:id])
  render :lookdetails
  end
  get :map  do
    
    @shops=Shop.all();
    render :map
  end
  get :server ,:with=>:id do
 shop=Shop.find(params[:id])
 @servers=shop.servers
    render :server
  end
  get :technician,:with=>:id do
shop=Shop.find(params[:id])
@technicians=shop.technicians
render :technician
  end
  get :order,:with=>:id do
    @server=Server.find(params[:id])
    render :order
  end
  get :myorders do
    shop=Shop.find(params[:shop_id])
    @orders=shop.orders.where(isuse:false)
    render :myorders
  end
get :appointment do
@order=Order.find(params[:order_id])
  render :appointment
end
get :choicehuman do
  @order=Order.find(params[:order_id])
  
  @technicians=@order.shop.technicians
  @choicesize=params[:choicesize]

  render :choicehuman
  end

  get :sure_order do
    @order=Order.find(params[:order_id])
    @order.update_attribute(:technician_id,params[:technician_id])
    @choicesize=params[:choicesize]
    render :sure_order
  end
  get :distribution_room do
    room=Room.where(size: params[:choicesize],:isuse=>0).first
    
    @order=Order.find(params[:order_id])
    @order.update_attributes(room_id:room._id,isuse:true)
    @order.technician.update_attributes(situation:false,wordtime:@order.server.usetime)

    @order.room.update_attribute(:isuse, @order.room.isuse+1)

    render :distribution_room
  end
end
