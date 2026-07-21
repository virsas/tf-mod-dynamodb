resource "aws_dynamodb_table" "vss" {
  name                        = var.ddb_name
  billing_mode                = var.ddb_billing_mode
  hash_key                    = var.ddb_hash_key
  range_key                   = var.ddb_range_key
  deletion_protection_enabled = var.ddb_deletion_protection

  # Only applicable for PROVISIONED billing mode
  read_capacity  = var.ddb_billing_mode == "PROVISIONED" ? var.ddb_read_capacity : null
  write_capacity = var.ddb_billing_mode == "PROVISIONED" ? var.ddb_write_capacity : null

  # Define all attributes for the table, primary key, and indexes
  dynamic "attribute" {
    for_each = var.ddb_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Configure Global Secondary Indexes
  dynamic "global_secondary_index" {
    for_each = var.ddb_gsi
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)

      # Only applicable for PROVISIONED billing mode
      read_capacity  = var.ddb_billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "read_capacity", null) : null
      write_capacity = var.ddb_billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "write_capacity", null) : null
    }
  }

  # Configure Local Secondary Indexes
  dynamic "local_secondary_index" {
    for_each = var.ddb_lsi
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  # Configure Time To Live (TTL)
  ttl {
    enabled        = var.ddb_ttl.enabled
    attribute_name = var.ddb_ttl.attribute_name
  }

  # Configure Server-Side Encryption
  server_side_encryption {
    enabled = var.ddb_encryption_enabled
  }

  # Configure Point-in-Time Recovery
  point_in_time_recovery {
    enabled = var.ddb_recovery_enabled
  }

  # Configure Global Table Replicas
  dynamic "replica" {
    for_each = var.ddb_replicas
    content {
      region_name = replica.value.region_name
    }
  }

  stream_enabled   = var.ddb_stream_enabled
  stream_view_type  = var.ddb_stream_view_type
}