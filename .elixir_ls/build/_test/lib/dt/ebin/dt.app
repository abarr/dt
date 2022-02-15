{application,dt,
             [{compile_env,[{dt,['Elixir.DtWeb.Gettext'],error}]},
              {applications,[kernel,stdlib,elixir,logger,runtime_tools,
                             phoenix,phoenix_html,phoenix_live_view,floki,
                             telemetry_metrics,telemetry_poller,gettext,jason,
                             plug_cowboy]},
              {description,"dt"},
              {modules,['Elixir.Dt','Elixir.Dt.Application','Elixir.DtWeb',
                        'Elixir.DtWeb.ChannelCase',
                        'Elixir.DtWeb.Components.DatePicker',
                        'Elixir.DtWeb.ConnCase','Elixir.DtWeb.Endpoint',
                        'Elixir.DtWeb.ErrorHelpers','Elixir.DtWeb.ErrorView',
                        'Elixir.DtWeb.Gettext','Elixir.DtWeb.LayoutView',
                        'Elixir.DtWeb.Page','Elixir.DtWeb.PageController',
                        'Elixir.DtWeb.PageView','Elixir.DtWeb.Router',
                        'Elixir.DtWeb.Router.Helpers',
                        'Elixir.DtWeb.Telemetry']},
              {registered,[]},
              {vsn,"0.1.0"},
              {mod,{'Elixir.Dt.Application',[]}}]}.