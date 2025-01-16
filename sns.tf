provider "aws" {
  region = "us-east-1"
}

# SNS Topic
resource "aws_sns_topic" "workflow_sns_topic" {
  name              = "workflow-sns-topic"
  kms_master_key_id = "arn:aws:kms:us-east-1:680185317484:key/07a9d545-50d7-485d-9df0-6a0c738d5be9"

  tags = {
    Environment = "Development"
    Project     = "WorkflowProject"
  }
}

# SQS Queue 1
resource "aws_sqs_queue" "workflow_sqs_queue_1" {
  name                        = "workflow-sqs-queue-1"
  visibility_timeout_seconds  = 30
  message_retention_seconds   = 345600
  kms_master_key_id           = "arn:aws:kms:us-east-1:680185317484:key/07a9d545-50d7-485d-9df0-6a0c738d5be9"
  kms_data_key_reuse_period_seconds = 300

  tags = {
    Environment = "Development"
    Project     = "WorkflowProject"
  }
}

# SQS Queue 2
resource "aws_sqs_queue" "workflow_sqs_queue_2" {
  name                        = "workflow-sqs-queue-2"
  visibility_timeout_seconds  = 30
  message_retention_seconds   = 345600
  kms_master_key_id           = "arn:aws:kms:us-east-1:680185317484:key/07a9d545-50d7-485d-9df0-6a0c738d5be9"
  kms_data_key_reuse_period_seconds = 300

  tags = {
    Environment = "Development"
    Project     = "WorkflowProject"
  }
}

# SQS Queue 1 Policy
resource "aws_sqs_queue_policy" "workflow_sqs_queue_1_policy" {
  queue_url = aws_sqs_queue.workflow_sqs_queue_1.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.workflow_sqs_queue_1.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.workflow_sns_topic.arn
          }
        }
      }
    ]
  })
}

# SQS Queue 2 Policy
resource "aws_sqs_queue_policy" "workflow_sqs_queue_2_policy" {
  queue_url = aws_sqs_queue.workflow_sqs_queue_2.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.workflow_sqs_queue_2.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.workflow_sns_topic.arn
          }
        }
      }
    ]
  })
}

# SNS to SQS Queue 1 Subscription
resource "aws_sns_topic_subscription" "workflow_subscription_1" {
  topic_arn = aws_sns_topic.workflow_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.workflow_sqs_queue_1.arn
}

# SNS to SQS Queue 2 Subscription
resource "aws_sns_topic_subscription" "workflow_subscription_2" {
  topic_arn = aws_sns_topic.workflow_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.workflow_sqs_queue_2.arn
}
