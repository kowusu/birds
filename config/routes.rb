Rails.application.routes.draw do
  get '/nodes/:node_a_id/common_ancestors/:node_b_id', to: 'nodes#common_ancestors'
end
