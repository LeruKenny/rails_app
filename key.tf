# Creating key pair
resource "aws_key_pair" "appkey" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key)}"
}