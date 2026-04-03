### Bước 1: Chuẩn bị "Mồi châm lửa" (AWS Secrets)

Vào mục **Variables** trên HCP Cloud, thêm 2 biến `env` ở trên: `AWS_ACCESS_KEY_ID` và `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`

### Bước 2: Điền thông tin "Thân chủ" (HCP Variables)

Cũng ở mục **Variables**, nhưng chọn loại **Terraform Variable** (Không phải `env`), thêm 2 biến này theo đúng code của bạn:

- `tfc_organization`: (Ví dụ: `thongvu-group`)
- Vì trong code có đoạn cấu hình này, nên chỉ cần cấu hình tfc_organization thôi.

```bash
    Condition = {
  StringLike = {
    # THẾ NÀY: Sẽ cho phép TẤT CẢ Workspace trong Organization của bạn mượn quyền AWS
    "app.terraform.io:sub": "organization:${var.tfc_organization}:project:*:workspace:*:run_phase:*"
  }
}
```

### Bước 3: Nhấn nút "Khởi công" (Apply)

Nhấn **New run** -> **Plan and Apply**. Terraform sẽ tự đi tìm Thumbprint, tự tạo Role, tự gán quyền Administrator cho Role đó. Khi xong, nó sẽ hiện ra một cái Output tên là: `tfc_aws_run_role_arn`. Tại đây dùng VCS thì chỉ cần commit code thay vì chạy bằng tay HCP sẽ tự trigger

### Bước 4: "Biến hình" thành OIDC (Cấu hình Chốt)

Khi đã có cái ARN ở Bước 3. Bạn quay lại mục **Variables**:

- Thêm biến `env`: `TFC_AWS_RUN_ROLE_ARN` (Giá trị là cái ARN bạn vừa copy).
- Thêm biến `env`: `TFC_AWS_PROVIDER_AUTH` (Giá trị là `true`).

### Bước 5: "Đốt Thuyền" (Về đích)

Bây giờ, bạn hãy MẠNH TAY XOÁ 2 cái biến `AWS_ACCESS_KEY_ID` và `AWS_SECRET_ACCESS_KEY` mà bạn vừa thêm ở Bước 1 đi.

---

**Kết quả:**
Bạn đã hoàn thành việc nâng cấp hệ thống AWS lên Trạng thái OIDC 100%. Từ nay về sau, Terraform sẽ không bao giờ hỏi Key của bạn nữa. Nó sẽ tự "biến hình" mượn quyền AWS cực xịn!
