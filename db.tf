
resource "aws_dynamodb_table" "myproject-table" {
    name = "myproject-table"
    read_capacity = 10
    write_capacity = 10
    hash_key = "Id"
    range_key = "Timestamp"
    attribute {
      name = "Id"
      type = "S"
    }
    attribute {
      name = "Timestamp"
      type = "N"
    }
}
