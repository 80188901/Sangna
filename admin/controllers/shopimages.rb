Sanna::Admin.controllers :shopimages do
  get :index do
    @title = "Shopimages"
    @shopimages = Shopimage.all
    render 'shopimages/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'shopimage')
    @shopimage = Shopimage.new
    render 'shopimages/new'
  end

  post :create do
    @shopimage = Shopimage.new(params[:shopimage])
    if @shopimage.save
      @title = pat(:create_title, :model => "shopimage #{@shopimage.id}")
      flash[:success] = pat(:create_success, :model => 'Shopimage')
      params[:save_and_continue] ? redirect(url(:shopimages, :index)) : redirect(url(:shopimages, :edit, :id => @shopimage.id))
    else
      @title = pat(:create_title, :model => 'shopimage')
      flash.now[:error] = pat(:create_error, :model => 'shopimage')
      render 'shopimages/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "shopimage #{params[:id]}")
    @shopimage = Shopimage.find(params[:id])
    if @shopimage
      render 'shopimages/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'shopimage', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "shopimage #{params[:id]}")
    @shopimage = Shopimage.find(params[:id])
    if @shopimage
      if @shopimage.update_attributes(params[:shopimage])
        flash[:success] = pat(:update_success, :model => 'Shopimage', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:shopimages, :index)) :
          redirect(url(:shopimages, :edit, :id => @shopimage.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'shopimage')
        render 'shopimages/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'shopimage', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Shopimages"
    shopimage = Shopimage.find(params[:id])
    if shopimage
      if shopimage.destroy
        flash[:success] = pat(:delete_success, :model => 'Shopimage', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'shopimage')
      end
      redirect url(:shopimages, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'shopimage', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Shopimages"
    unless params[:shopimage_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'shopimage')
      redirect(url(:shopimages, :index))
    end
    ids = params[:shopimage_ids].split(',').map(&:strip)
    shopimages = Shopimage.find(ids)
    
    if shopimages.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Shopimages', :ids => "#{ids.to_sentence}")
    end
    redirect url(:shopimages, :index)
  end
end
