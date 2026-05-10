Application.put_env(:ex_fpl, :req_options, plug: {Req.Test, ExFPL.HTTPStub})
ExUnit.start()
