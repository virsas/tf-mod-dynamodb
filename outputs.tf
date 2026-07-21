output "aws_dynamodb_table_id" {
  description = "The ID of the DynamoDB table."
  value       = try(aws_dynamodb_table.vss.id, null)
}

output "aws_dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table."
  value       = try(aws_dynamodb_table.vss.arn, null)
}

output "aws_dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = try(aws_dynamodb_table.vss.name, null)
}

output "aws_dynamodb_table_stream_arn" {
  description = "The ARN of the DynamoDB table stream. This will only have a value if a stream is enabled on the table."
  value       = try(aws_dynamodb_table.vss.stream_arn, null)
}

output "aws_dynamodb_table_stream_label" {
  description = "The label of the DynamoDB table stream. This will only have a value if a stream is enabled."
  value       = try(aws_dynamodb_table.vss.stream_label, null)
}