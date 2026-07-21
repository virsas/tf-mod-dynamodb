variable "ddb_name" {
  description = "The name of the DynamoDB table. This must be unique in your AWS account and region."
  type        = string
  default     = ""
  validation {
    condition     = length(var.ddb_name) > 0
    error_message = "The 'ddb_name' variable is required."
  }
}

# Table Schema & Keys
variable "ddb_attributes" {
  description = "A list of attribute definitions for the table. All key attributes (for the table and any indexes) must be defined here."
  type = list(object({
    name = string
    type = string # S for String, N for Number, B for Binary
  }))
  default = []
}

variable "ddb_hash_key" {
  description = "The attribute name of the hash key (partition key)."
  type        = string
  default     = ""
  validation {
    condition     = length(var.ddb_hash_key) > 0
    error_message = "The 'db_hash_key' variable is required."
  }
}

variable "ddb_range_key" {
  description = "The attribute name of the range key (sort key), if applicable."
  type        = string
  default     = null
}

# Capacity & Billing
variable "ddb_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity. Valid values are 'PROVISIONED' or 'PAY_PER_REQUEST'."
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.ddb_billing_mode)
    error_message = "Invalid value for 'ddb_billing_mode'. Must be one of: 'PROVISIONED', 'PAY_PER_REQUEST'."
  }
}

variable "ddb_read_capacity" {
  description = "The number of read capacity units for the table. Required if 'ddb_billing_mode' is 'PROVISIONED'."
  type        = number
  default     = 5
}

variable "ddb_write_capacity" {
  description = "The number of write capacity units for the table. Required if 'ddb_billing_mode' is 'PROVISIONED'."
  type        = number
  default     = 5
}

# Features & Protection
variable "ddb_deletion_protection" {
  description = "Enables deletion protection for the table."
  type        = bool
  default     = false
}

variable "ddb_encryption_enabled" {
  description = "Enables server-side encryption. Defaults to true."
  type        = bool
  default     = true
}

variable "ddb_recovery_enabled" {
  description = "Enables point-in-time recovery. Defaults to false."
  type        = bool
  default     = false
}

variable "ddb_ttl" {
  description = "Configuration for the Time To Live (TTL) feature."
  type = object({
    enabled        = bool
    attribute_name = string
  })
  default = {
    enabled        = false
    attribute_name = ""
  }
}

# Indexes & Replicas
variable "ddb_gsi" {
  description = "A list of global secondary indexes to create on the table."
  type        = any # Using 'any' for flexibility with optional attributes
  default     = []
}

variable "ddb_lsi" {
  description = "A list of local secondary indexes to create on the table."
  type        = any # Using 'any' for flexibility with optional attributes
  default     = []
}

variable "ddb_replicas" {
  description = "A list of regions where replicas of the table will be created for a global table."
  type = list(object({
    region_name = string
  }))
  default = []
}

variable "ddb_stream_enabled" {
  description = "Enables DynamoDB Streams for the table."
  type        = bool
  default     = false
}

variable "ddb_stream_view_type" {
  description = "The view type for the DynamoDB Stream. Valid values are 'NEW_IMAGE', 'OLD_IMAGE', 'NEW_AND_OLD_IMAGES', or 'KEYS_ONLY'."
  type        = string
  default     = null

  validation {
    condition = var.ddb_stream_view_type == null || contains(
      ["NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES", "KEYS_ONLY"],
      try(var.ddb_stream_view_type, "")
    )
    error_message = "Invalid value for 'ddb_stream_view_type'. Must be one of: 'NEW_IMAGE', 'OLD_IMAGE', 'NEW_AND_OLD_IMAGES', 'KEYS_ONLY'."
  }
}