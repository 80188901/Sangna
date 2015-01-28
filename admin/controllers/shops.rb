Sanna::Admin.controllers :shops do
  get :index do
    @title = "Shops"
    @shops = Shop.all
    render 'shops/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'shop')
    @shop = Shop.new
    render 'shops/new'
  end

  post :create do
    @shop = Shop.new(params[:shop])
    if @shop.save
      @title = pat(:create_title, :model => "shop #{@shop.id}")
      flash[:success] = pat(:create_success, :model => 'Shop')
      params[:save_and_continue] ? redirect(url(:shops, :index)) : redirect(url(:shops, :edit, :id => @shop.id))
    else
      @title = pat(:create_title, :model => 'shop')
      flash.now[:error] = pat(:create_error, :model => 'shop')
      render 'shops/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "shop #{params[:id]}")
    @shop = Shop.find(params[:id])
    if @shop
      render 'shops/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'shop', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "shop #{params[:id]}")
    @shop = Shop.find(params[:id])
    if @shop
      if @shop.update_attributes(params[:shop])
        flash[:success] = pat(:update_success, :model => 'Shop', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:shops, :index)) :
          redirect(url(:shops, :edit, :id => @shop.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'shop')
        render 'shops/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'shop', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Shops"
    shop = Shop.find(params[:id])
    if shop
      if shop.destroy
        flash[:success] = pat(:delete_success, :model => 'Shop', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'shop')
      end
      redirect url(:shops, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'shop', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Shops"
    unless params[:shop_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'shop')
      redirect(url(:shops, :index))
    end
    ids = params[:shop_ids].split(',').map(&:strip)
    shops = Shop.find(ids)
    
    if shops.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Shops', :ids => "#{ids.to_sentence}")
    end
    redirect url(:shops, :index)
  end
end
