resources :stopwatch_timers, only: %i(new create edit update) do
  collection do
    get :current
  end
  member do
    put :start
    put :stop
  end
end

