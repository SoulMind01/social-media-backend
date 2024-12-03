resource "aws_dynamodb_table" "app_table" {
  name         = "AppTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "AppDynamoDBTable"
  }
}

resource "aws_elasticache_parameter_group" "app_cache_param_group" {
  name        = "app-cache-param-group"
  family      = "redis7"
  description = "Parameter group for Redis 7"
}

resource "aws_elasticache_cluster" "app_cache" {
  cluster_id           = "app-cache"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.app_cache_param_group.name
  security_group_ids   = [aws_security_group.elasticache_access_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.app_subnet_group.name

  tags = {
    Name = "AppElastiCache"
  }
}



resource "aws_s3_bucket" "app_bucket" {
  bucket = "app-bucket-${random_string.s3_suffix.result}"

  tags = {
    Name = "AppBucket"
  }
}

resource "random_string" "s3_suffix" {
  length  = 8
  special = false
  upper   = false
}


resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

