Rails.application.routes.draw do
  get "/lines/:line_number", to: "lines#get", constraints: { line_number: /\d+/ }
end
