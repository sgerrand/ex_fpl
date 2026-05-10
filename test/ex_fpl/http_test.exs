defmodule ExFPL.HTTPTest do
  use ExUnit.Case, async: true

  alias ExFPL.{HTTP, Session}

  test "returns {:ok, body} on a 200 response" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn -> Req.Test.json(conn, %{"ok" => true}) end)
    assert {:ok, %{"ok" => true}} = HTTP.get("/anything/")
  end

  test "passes query params" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert conn.query_string =~ "event=5"
      Req.Test.json(conn, [])
    end)

    assert {:ok, []} = HTTP.get("/fixtures/", params: [event: 5])
  end

  test "sends cookie header when given a session" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert ["pl_profile=secret"] = Plug.Conn.get_req_header(conn, "cookie")
      Req.Test.json(conn, %{})
    end)

    session = Session.new(cookie: "pl_profile=secret")
    assert {:ok, _} = HTTP.get("/me/", session: session)
  end

  test "no cookie header is sent without a session" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert Plug.Conn.get_req_header(conn, "cookie") == []
      Req.Test.json(conn, %{})
    end)

    assert {:ok, _} = HTTP.get("/anything/")
  end

  test "returns {:error, {:http_error, status, body}} on non-2xx" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.send_resp(404, ~s({"detail":"not found"}))
    end)

    assert {:error, {:http_error, 404, %{"detail" => "not found"}}} = HTTP.get("/missing/")
  end

  test "returns {:error, reason} on transport failure" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn -> Req.Test.transport_error(conn, :econnrefused) end)

    assert {:error, %Req.TransportError{reason: :econnrefused}} =
             HTTP.get("/boom/", retry: false)
  end

  test "emits a telemetry event for each request" do
    ref = make_ref()
    handler_id = "ExFPL-http-test-#{inspect(ref)}"

    :telemetry.attach(
      handler_id,
      [:ExFPL, :http, :request],
      &__MODULE__.forward_telemetry/4,
      %{pid: self(), ref: ref}
    )

    Req.Test.stub(ExFPL.HTTPStub, fn conn -> Req.Test.json(conn, %{}) end)
    assert {:ok, _} = HTTP.get("/whatever/")

    assert_receive {:telemetry, ^ref, [:ExFPL, :http, :request], %{duration: dur},
                    %{path: "/whatever/", result: :ok}}

    assert is_integer(dur) and dur >= 0

    :telemetry.detach(handler_id)
  end

  def forward_telemetry(event, measurements, metadata, %{pid: pid, ref: ref}) do
    send(pid, {:telemetry, ref, event, measurements, metadata})
  end
end
