require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Lockup::Engine, at: '/lockup' if Rails.env.staging?
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Rails.application.secrets.sidekiq_username && password == Rails.application.secrets.sidekiq_password
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  resources :bookings, path: 'boeken', param: :token, only: [:create] do
    resources :build, path: 'stap', controller: 'bookings/build',
                      only: [:show, :update]
    resource :payment, param: :token, only: [:new, :show]
    resources :coupon_redemptions, path: 'coupon', only: [:create]
  end

  resources :activations, path: 'activeer', param: :code, only: [:show, :update]
  resources :faqs, only: :index, path: 'veelgestelde-vragen'
  resources :packages, only: :index, path: 'themas'

  # Routes for static pages
  get '/hoe-het-werkt', to: 'pages#how_it_works'
  get '/bedrijfs-informatie', to: 'pages#company_info'
  get '/restaurant-info', to: 'pages#restaurant_info'

  scope '/hooks', controller: :hooks do
    get :sms_status_report
    post :mollie_webhook
  end

  # Personal booking page
  get ':booking_slug', to: 'bookings#show', as: 'booking_slug'

  root 'home#index'
end
