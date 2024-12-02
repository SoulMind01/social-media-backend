resource "aws_wafv2_web_acl" "app_waf" {
  name        = "App-WAF"
  description = "Web ACL for API Gateway"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "app_waf_metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "block-bad-requests"
    priority = 1

    action {
      block {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }

        positional_constraint = "CONTAINS"
        search_string         = "badbot"
        text_transformation {
          priority = 1
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block_bad_requests"
      sampled_requests_enabled   = true
    }
  }
}
