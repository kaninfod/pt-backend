Rails.application.routes.draw do
  namespace :api do

    post 'authenticate', to: 'authentication#authenticate'
    get 'authentication/validate', to: 'authentication#validate_token'


    resources :photofiles
    get 'photofiles/:id/photoserve' => 'photofiles#photoserve'
    patch 'photofiles/:id/rotate' => 'photofiles#rotate'
    get 'photofiles/:id/phash' => 'photofiles#phash'



    put '/albums/:id/photo/:photo' => "albums#add_photo"
    get '/albums/:id/photos' => 'albums#photos'
    resources :albums

    match 'albums/select' => 'albums/select', via: [:get, :post]
    get '/albums/get_tag_list' => "albums#get_tag_list"

    get 'pages' => 'pages#index'

    match "photos/(q/*query)" => "photos#index", :via => [:post, :get]
    get '/photos/get_tag_list' => 'photos#get_tag_list'
    get '/photos/valid_date/:type/:date' => 'photos#valid_date'
    resources :photos, :except => [:create, :index]
    get '/photos/:id/image/:size' => 'photos#image'
    get '/photos/:id/rotate/(:degrees)' => 'photos#rotate'
    post '/photos/:id/add_comment' => 'photos#add_comment'
    get '/photos/:id/like' => 'photos#like'
    get '/photos/:id/addtag' => 'photos#addtag'
    get '/photos/:id/removetag' => 'photos#removetag'
    get '/photos/:id/show_small' => 'photos#show_small'



    post '/catalogs/create'  => 'catalogs#create'
    get '/catalogs/oauth_verify'  => 'catalogs#oauth_verify'
    get '/catalogs/:id/import' => 'catalogs#import'
    get '/catalogs/:id/photos' => 'catalogs#photos'
    resources :catalogs

    get '/catalogs/migrate' => 'catalogs#migrate'
    get '/catalogs/authorize' => 'catalogs#authorize'
    put '/catalogs/authorize' => 'catalogs#authorize'
    get '/catalogs/authorize_callback' => 'catalogs#authorize_callback'

    get '/catalogs/:id/dashboard' => 'catalogs#dashboard'
    get '/catalogs/:id/get_catalog' => 'catalogs#get_catalog'
    match "/catalogs/:id/edit" => "catalogs#edit", via: [:get, :post]
    get "/catalogs/:id/destroy" => "catalogs#destroy"
    # match '/catalogs/:id/import' => 'catalogs#import', via: [:get, :post]

    get '/locations/countries'
    get '/locations/cities'
    get '/locations/create'
    get '/locations/new'
    get '/locations/lookup_address'
    get '/locations/lookup'
    get 'locations/new_from_coordinate_string' => 'locations#new_from_coordinate_string'
    get 'locations/typeahead/:query' => 'locations#typeahead'
    resources :locations
    get '/locations/:id/view' => 'locations#view'

    post    'bucket/:id/toggle'     => 'bucket#toggle'
    post    'bucket/:id/add'        => 'bucket#add'
    post    'bucket/add_to_album'   => 'bucket#add_to_album'
    delete  'bucket/:id/remove'     => 'bucket#remove'
    post    'bucket/like'           => 'bucket#like'
    post    'bucket/unlike'         => 'bucket#unlike'
    get     'bucket/widget'         => 'bucket#widget'
    post    '/bucket/rotate'        => 'bucket#rotate'
    post    'bucket/add_comment'    => 'bucket#add_comment'
    post    'bucket/add_tag'    => 'bucket#add_tag'

    get  'bucket/list' => 'bucket#list'
    get  'bucket' => 'bucket#index'
    get  'bucket/clear' => 'bucket#clear'
    get  'bucket/count' => 'bucket#count'
    get  'bucket/save' => 'bucket#save_to_album'
    get  'bucket/delete_photos' => 'bucket#delete_photos'
    get  'bucket/edit' => 'bucket#edit'
    patch  'bucket/update' => 'bucket#update'

    resources :photofiles
    get 'photofiles/:id/photoserve' => 'photofiles#photoserve'
    patch 'photofiles/:id/rotate' => 'photofiles#rotate'
    get 'photofiles/:id/phash' => 'photofiles#phash'

    post 'jobs/list' => 'jobs#list'
    resources :jobs
  end

  Rails.application.routes.draw do
    resources :users, controller: 'users', only: [:create, :edit, :update]
  end

  mount Resque::Server.new, at: "/resque"
  root to: 'photos#index'

end
