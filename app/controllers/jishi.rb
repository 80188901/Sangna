Sanna::App.controllers :jishi do
  
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
    get :personal do
    @technician=Technician.find(params[:technician_id])
    render :personal
  end
  get :myorder do
    if !params[:day]
    @orders=Order.where(technician_id:params[:technician_id])
  else

    @orders=Order.where(technician_id:params[:technician_id]).where(applydate:(Time.now.midnight-params[:day].to_i.day)..(Time.now.midnight))

  end
  
    render :myorder
  end
  get :checknew do
    technician=Technician.find(params[:technician_id])
      if technician.orders.where(isnow:true).first
        render :html,"true"
      end

  end
  get :handel do
    technician=Technician.find(params[:technician_id])
    @order=technician.orders.where(isnow:true).first
    if !@order
      flash[:error]='当前没有你的订单'
      redirect(url("/jishi/#{params[:technician_id]}"))

end
    render :handel
  end
  get :orderdetails do
    @order=Order.find(params[:order_id])
    render :orderdetails
  end
  get :index,:with=>:id do
    @technician=Technician.find(params[:id])
    render :index
  end


end
