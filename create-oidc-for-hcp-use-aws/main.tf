# A. Tự động lấy "Chứng chỉ bảo mật" của app.terraform.io (Cực xịn!)
data "tls_certificate" "tfc_certificate" {
  url = "https://app.terraform.io"
}

# B. Khai báo OIDC Provider cho Terraform Cloud 
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = "https://app.terraform.io"
  
  # Giải pháp 400 Bad Request: Chấp nhận cả 2 loại Audience (Khán giả)
  client_id_list  = ["sts.amazonaws.com", "aws.workload.identity"] 
  
  # Lấy mã bảo mật tự động từ cái Data Source ở trên
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

# C. Tạo IAM Role cho phép "Mượn quyền" (Dùng biến đã khai báo)
resource "aws_iam_role" "tfc_role" {  # <-- Đã đổi thành Gạch Dưới (_) chuẩn HCL
  name = var.aws_oidc_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.tfc_provider.arn
        }
        Condition = {
          StringLike = {
            # Giới hạn đúng Organization của bạn (Dự án/Workspace mở rộng dấu *)
            "app.terraform.io:sub" : "organization:${var.tfc_organization}:project:*:workspace:*:run_phase:*"
            
            # Chấp nhận cả 2 loại mã Audience gửi sang
            "app.terraform.io:aud" : ["sts.amazonaws.com", "aws.workload.identity"]
          }
        }
      }
    ]
  })
}

# D. Cấp quyền Administrator cho cái Role này
resource "aws_iam_role_policy_attachment" "tfc_policy_attach" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# --- OUTPUT ---
output "tfc_aws_run_role_arn" {
  description = "Bạn hãy COPY cái ARN này dán vào biến TFC_AWS_RUN_ROLE_ARN trên Cloud nhé!"
  value       = aws_iam_role.tfc_role.arn
}

