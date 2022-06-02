Rails.application.routes.draw do
  get 'throw', to: "throw#index"
  get 'result', to: "throw#result"
end
