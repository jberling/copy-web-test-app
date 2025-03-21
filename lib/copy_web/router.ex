defmodule CopyWeb.Router do
  use CopyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CopyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CopyWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/strange", StrangeViewLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CopyWeb do
  #   pipe_through :api
  # end
end
