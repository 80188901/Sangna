Sanna::Admin.controllers :technicians do
  get :index do
    @title = "Technicians"
    @technicians = Technician.all
    render 'technicians/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'technician')
    @technician = Technician.new
    render 'technicians/new'
  end

  post :create do
    @technician = Technician.new(params[:technician])
    if @technician.save
      @title = pat(:create_title, :model => "technician #{@technician.id}")
      flash[:success] = pat(:create_success, :model => 'Technician')
      params[:save_and_continue] ? redirect(url(:technicians, :index)) : redirect(url(:technicians, :edit, :id => @technician.id))
    else
      @title = pat(:create_title, :model => 'technician')
      flash.now[:error] = pat(:create_error, :model => 'technician')
      render 'technicians/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "technician #{params[:id]}")
    @technician = Technician.find(params[:id])
    if @technician
      render 'technicians/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'technician', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "technician #{params[:id]}")
    @technician = Technician.find(params[:id])
    if @technician
      if @technician.update_attributes(params[:technician])
        flash[:success] = pat(:update_success, :model => 'Technician', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:technicians, :index)) :
          redirect(url(:technicians, :edit, :id => @technician.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'technician')
        render 'technicians/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'technician', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Technicians"
    technician = Technician.find(params[:id])
    if technician
      if technician.destroy
        flash[:success] = pat(:delete_success, :model => 'Technician', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'technician')
      end
      redirect url(:technicians, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'technician', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Technicians"
    unless params[:technician_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'technician')
      redirect(url(:technicians, :index))
    end
    ids = params[:technician_ids].split(',').map(&:strip)
    technicians = Technician.find(ids)
    
    if technicians.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Technicians', :ids => "#{ids.to_sentence}")
    end
    redirect url(:technicians, :index)
  end
end
