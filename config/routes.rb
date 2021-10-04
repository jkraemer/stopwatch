resources :stopwatch_timers, only: %i(new create edit update) do
  collection do
    get :current
    post :update_form
  end
  member do
    put :start
    put :stop
  end
end

