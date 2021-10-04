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

scope 'issues/:issue_id' do
  post 'timer/start', to: 'stopwatch_issue_timers#start', as: :start_issue_timer
  post 'timer/stop',  to: 'stopwatch_issue_timers#stop',  as: :stop_issue_timer
end

