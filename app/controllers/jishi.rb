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
  get :showlogin do
    render :showlogin
  end
  post :login do
     @technician=Technician.where(name:params[:username],password:params[:password]).first
     if @technician
        redirect(url("jishi/#{@technician._id}")) 
      else
        flash.now[:error]='用户名或密码错误'
        render "jishi/showlogin"
     end
  end
  get :upclock do
    order=Order.find(params[:order_id])
    technician=order.technician
    if technician.password==params[:password]
      technician.update_attributes(iswork:true,wordtime:Time.now+order.server.usetime.to_i.minute)
      render :html,'true'
    else
      render :html,'false'
    end
  end
get :downclock do
     order=Order.find(params[:order_id])
    technician=order.technician
    if technician.password==params[:password]
      technician.update_attributes(iswork:false,wordtime:" ",situation:true)
      order.room.update_attribute(:isuse,0)
      order.update_attributes(isnow:false,remark:params[:tip])

      render :html,'true'
    else
      render :html,'false'
    end
end
    get :personal do
    @technician=Technician.find(params[:technician_id])
    render :personal
  end
  get :myorder do
    if !params[:day]
    @orders=Order.where(technician_id:params[:technician_id])
  else

    @orders=Order.where(technician_id:params[:technician_id]).where(applydate:(Time.now-params[:day].to_i.day)..(Time.now)).asc(:applydate)

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
