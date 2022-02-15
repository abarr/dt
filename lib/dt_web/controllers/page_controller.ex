defmodule DtWeb.PageController do
  use DtWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
