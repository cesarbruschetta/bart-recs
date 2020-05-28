
resource "aws_cloudwatch_log_group" "bartSimulatorTasksLogs" {
  name = "bart-simulator"
 
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }
}
