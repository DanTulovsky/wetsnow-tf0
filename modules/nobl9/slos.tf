# https://docs.nobl9.com/Sources/lightstep/
resource "nobl9_slo" "web_static_latency" {
  name             = "${nobl9_service.web_static.name}-latency"
  service          = nobl9_service.web_static.name
  budgeting_method = "Occurrences"
  project          = nobl9_project.wetsnow.name

  alert_policies = [
    "Default Alert"
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
    name = "webstatic-latency-agent"
    raw_metric {
      lightstep {
        stream_id    = "XTLbMfjL"
        type_of_data = "latency"
        percentile   = "99"
      }
    }
  }
}