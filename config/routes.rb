Rails.application.routes.draw do
  match 'add' => 'reports#add', via: :post
  match 'generate' => 'reports#generate', via: :post
end
