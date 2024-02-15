resource "aws_key_pair" "project-key" {
  key_name   = "projectKey"
  public_key = file(var.PUBLIC_KEY_PATH)

}