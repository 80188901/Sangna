Sanna::Admin.controllers :technician_infos do
  get :index do
    @title = "Technician_infos"
    @technician_infos = TechnicianInfo.all
    render 'technician_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'technician_info')
    @technician_info = TechnicianInfo.new
    render 'technician_infos/new'
  end

  post :create do
    @technician_info = TechnicianInfo.new(params[:technician_info])
    if @technician_info.save
      @title = pat(:create_title, :model => "technician_info #{@technician_info.id}")
      flash[:success] = pat(:create_success, :model => 'TechnicianInfo')
      params[:save_and_continue] ? redirect(url(:technician_infos, :index)) : redirect(url(:technician_infos, :edit, :id => @technician_info.id))
    else
      @title = pat(:create_title, :model => 'technician_info')
      flash.now[:error] = pat(:create_error, :model => 'technician_info')
      render 'technician_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "technician_info #{params[:id]}")
    @technician_info = TechnicianInfo.find(params[:id])
    if @technician_info
      render 'technician_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'technician_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "technician_info #{params[:id]}")
    @technician_info = TechnicianInfo.find(params[:id])
    if @technician_info
      if @technician_info.update_attributes(params[:technician_info])
        flash[:success] = pat(:update_success, :model => 'Technician_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:technician_infos, :index)) :
          redirect(url(:technician_infos, :edit, :id => @technician_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'technician_info')
        render 'technician_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'technician_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Technician_infos"
    technician_info = TechnicianInfo.find(params[:id])
    if technician_info
      if technician_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Technician_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'technician_info')
      end
      redirect url(:technician_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'technician_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Technician_infos"
    unless params[:technician_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'technician_info')
      redirect(url(:technician_infos, :index))
    end
    ids = params[:technician_info_ids].split(',').map(&:strip)
    technician_infos = TechnicianInfo.find(ids)
    
    if technician_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Technician_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:technician_infos, :index)
  end
end
