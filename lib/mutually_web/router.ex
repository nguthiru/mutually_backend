defmodule MutuallyWeb.Router do
  alias MutuallyWeb.Accounts.GuardianErrorHandler
  use MutuallyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Guardian.Plug.Pipeline,
      module: MutuallyWeb.Accounts.Guardian,
      error_handler: GuardianErrorHandler

    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
    plug MutuallyWeb.Plugs.ProfilePlug
  end

  scope "/api", MutuallyWeb do
    pipe_through :api

    scope "/auth" do
      post "/register", UsersController, :register
      post "/login", UsersController, :login
      post "/logout", UsersController, :logout
    end

    scope "/profile" do
      pipe_through :authenticated
      get "/me", ProfileController, :me
      get "/invite", ProfileController, :get_invite_link
      get "/invite/:link/accept", ProfileController, :accept_invite
      get "/:id", ProfileController, :show
      post "/", ProfileController, :create
      put "/", ProfileController, :update
    end

    scope "/mutual" do
      pipe_through :authenticated
      get "/", MutualController, :index
      get "/:id", MutualController, :show
      delete "/:id", MutualController, :remove_mutual
      put "/:id", MutualController, :update_mutual
      get "/:id/activities", MutualController, :mutual_activities


      scope "/:id/appointments" do
        get "/", AppointmentController, :mutual_appointments
        get "/:appointment_id", AppointmentController, :show_mutual_appointments
        post "/", AppointmentController, :create
        put "/:appointment_id", AppointmentController, :update
        delete "/:appointment_id", AppointmentController, :delete
      end

      scope "/:id/vault" do
        get "/", VaultController, :index
        get "/:vault_item_id", VaultController, :show
        post "/", VaultController, :create
        delete "/:vault_item_id", VaultController, :delete
      end

    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:mutually, :dev_routes) do
  # If you want to use the LivaeDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: MutuallyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
