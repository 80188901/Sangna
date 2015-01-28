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

end
