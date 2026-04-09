defmodule ExChat.Web.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ExChat.UseCases.CreateUser
  alias ExChat.Web.Router

  test "POST /users returns 201 with username and access token when user is created" do
    with_mock(CreateUser, on: fn(_) -> {:ok, %{username: "alice", access_token: "a_token"}} end) do
      conn =
        conn(:post, "/users", Poison.encode!(%{username: "alice"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(Router.init([]))

      assert conn.status == 201
      assert Poison.decode!(conn.resp_body) == %{"username" => "alice", "access_token" => "a_token"}
      assert called CreateUser.on("alice")
    end
  end

  test "POST /users returns 409 when the username is already taken" do
    with_mock(CreateUser, on: fn(_) -> {:error, "username already taken"} end) do
      conn =
        conn(:post, "/users", Poison.encode!(%{username: "alice"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(Router.init([]))

      assert conn.status == 409
      assert Poison.decode!(conn.resp_body) == %{"error" => "username already taken"}
    end
  end

  test "POST /users returns 400 when username is missing" do
    conn =
      conn(:post, "/users", Poison.encode!(%{}))
      |> put_req_header("content-type", "application/json")
      |> Router.call(Router.init([]))

    assert conn.status == 400
    assert Poison.decode!(conn.resp_body) == %{"error" => "username is required"}
  end

  test "POST /users returns 400 when username is empty" do
    conn =
      conn(:post, "/users", Poison.encode!(%{username: ""}))
      |> put_req_header("content-type", "application/json")
      |> Router.call(Router.init([]))

    assert conn.status == 400
    assert Poison.decode!(conn.resp_body) == %{"error" => "username is required"}
  end
end
