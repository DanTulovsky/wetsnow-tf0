# https://docs.nobl9.com/Sources/lightstep/
# https://docs.nobl9.com/yaml-guide/#objective

resource "nobl9_slo" "web_static_latency" {
  name             = "${nobl9_service.web_static.name}-latency"
  service          = nobl9_service.web_static.name
  budgeting_method = "Occurrences"
  project          = nobl9_project.wetsnow.name

  alert_policies = [
    nobl9_alert_policy.default_alert_policy.name,
  ]

  time_window {
    unit       = "Day"
    count      = 28
    is_rolling = true
  }

  objective {
    target       = 0.99
    display_name = "OK"
    value        = 60
    op           = "lte"
  }

  indicator {
    #    name    = nobl9_agent.lightstep0.name
    # This is the name of the agent
    name = "lightstep"
    #    kind    = "agent"
    project = nobl9_project.wetsnow.name

    raw_metric {
      lightstep {
        stream_id    = "XTLbMfjL"
        type_of_data = "latency"
        percentile   = "99"
      }
    }
  }
}

resource "nobl9_slo" "web_static_availability" {
  name             = "${nobl9_service.web_static.name}-availability"
  service          = nobl9_service.web_static.name
  budgeting_method = "Occurrences"
  project          = nobl9_project.wetsnow.name

  alert_policies = [
    nobl9_alert_policy.default_alert_policy.name,
  ]

  time_window {
    unit       = "Day"
    count      = 28
    is_rolling = true
  }

  objective {
    target       = 0.99
    display_name = "OK"
    value        = 1 # not used
    count_metrics {
      incremental = false
      good {
        lightstep {
          stream_id    = "XTLbMfjL"
          type_of_data = "good"
        }
      }
      total {
        lightstep {
          stream_id    = "XTLbMfjL"
          type_of_data = "total"
        }
      }
    }
  }

  indicator {
    #    name    = nobl9_agent.lightstep0.name
    # This is the name of the agent
    name    = "lightstep"
    project = nobl9_project.wetsnow.name
  }
}
