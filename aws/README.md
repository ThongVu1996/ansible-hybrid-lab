# Terraform Hybrid Lab - AWS & Ansible

Dự án này sử dụng Terraform để triển khai hạ tầng mạng (VPC) và máy chủ Web (EC2) trên AWS. Hệ thống được thiết kế để kết nối với cơ sở dữ liệu trên Proxmox thông qua mạng Tailscale và cấu hình bởi Ansible.

## Các biến cần chuẩn bị (Terraform Variables)

Để dự án chạy thành công, bạn cần chuẩn bị các biến sau trong file `terraform.tfvars` hoặc cấu hình trên HCP Terraform:

| Tên biến | Mô tả | Loại | Giá trị mặc định |
| :--- | :--- | :--- | :--- |
| `AWS_DEFAULT_REGION` | Region triển khai AWS | String | `ap-southeast-1` |
| `vpc_cidr` | Dải IP của VPC | String | `10.0.0.0/16` |
| `key_name` | Tên SSH Key Pair đã có trên AWS | String | **Bắt buộc** |
| `ts_auth_key` | Tailscale Auth Key (để join mạng) | Sensitive | **Bắt buộc** |
| `ssh_private_key` | Private Key để clone code từ Git | Sensitive | **Bắt buộc** |
| `db_host_tailscale` | Hostname MagicDNS của database (Proxmox) | String | **Bắt buộc** |
| `db_name` | Tên Database Laravel | String | **Bắt buộc** |
| `db_user` | User Database Laravel | String | **Bắt buộc** |
| `db_password` | Mật khẩu Database Laravel | Sensitive | **Bắt buộc** |

## Cấu trúc dự án

```text
.
├── ansible/            # Các playbook/role cấu hình máy chủ
├── terraform/          # Mã nguồn hạ tầng AWS
│   ├── modules/        # Module con (vpc, ec2)
│   ├── scripts/        # Script bootstrap (setup.sh)
│   ├── main.tf         # File thực thi chính
│   └── variables.tf    # Khai báo biến
└── README.md
```

## Các bước triển khai

1.  Truy cập vào thư mục `terraform`.
2.  Khởi tạo: `terraform init`
3.  Kiểm tra: `terraform plan`
4.  Triển khai: `terraform apply`
5.  Sau khi EC2 đã online trên Tailscale, chạy Ansible để cài đặt ứng dụng.
