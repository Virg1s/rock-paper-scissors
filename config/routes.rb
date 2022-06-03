Rails.application.routes.draw do
  get 'throw', to: "throw#index"
  get 'result', to: "throw#result"
  get 'crub_busy', to: "throw#crub_busy"
end
