resource "nobl9_alert_policy" "slow_burn_72h" {
  name         = "web-static"
  project      = nobl9_project.wetsnow.name
  display_name = "web-static"
  severity     = "Low"
  description  = "Alert when error budget would be exhausted in 72h"

  condition {
    measurement  = "timeToBurnBudget"
    value_string = "72h"
    lasts_for    = "30m"
  }

  alert_method {
    name = nobl9_alert_method_email.default.name
  }

  alert_method {
    name = nobl9_alert_method_jira.jira_ticket.name
  }
}

