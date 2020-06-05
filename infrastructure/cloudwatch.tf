
resource "aws_cloudwatch_log_group" "bartSimulatorTasksLogs" {
  name = "bart-simulator"
  retention_in_days = 5
 
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }
}
