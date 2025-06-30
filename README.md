# secure_aws_architecture_using_terraform


# 🔐 Secure AWS VPC with Public & Private EC2 Instances via Terraform

## 📋 Overview

This Terraform configuration provisions a secure and scalable AWS environment with:

- A custom VPC and subnets (public & private)
- A public EC2 instance (Bastion host)
- A private EC2 instance with no public IP
- A NAT Gateway for secure outbound internet access from private EC2
- Security groups with controlled SSH/HTTP access

---

## 🛠️ Infrastructure Components

| Resource                | Description |
|-------------------------|-------------|
| **VPC**                | Custom VPC with CIDR `10.10.0.0/16` |
| **Subnets**            | 3 public subnets and 3 private subnets in different AZs |
| **Internet Gateway**   | For internet access to public subnet |
| **Elastic IP (EIP)**   | For the NAT Gateway |
| **NAT Gateway**        | Enables outbound access for private EC2 |
| **Route Tables**       | Separate route tables for public and private subnets |
| **Security Group**     | Allows SSH (port 22) and HTTP (port 80) traffic |
| **EC2 Instances**      | One public (bastion) and one private (secure) instance |

---

## 📦 What You’ve Achieved

- ✅ EC2 in **private subnet** with **no public IP**
- ✅ Secure **bastion host** in public subnet
- ✅ **SSH access** to private EC2 through public EC2
- ✅ **Outbound internet** from private EC2 using NAT Gateway
- ✅ Reproducible setup with Terraform

---

## 🛡️ Security Best Practices Applied

| Practice                         | Purpose |
|----------------------------------|---------|
| 🔒 Private EC2 has no public IP  | Eliminates direct internet exposure |
| 🔁 NAT Gateway for outbound only | No inbound access possible via NAT |
| 🧱 Bastion host for SSH access   | Acts as secure jump server |
| ✅ Principle of Least Privilege  | Only essential ports open |
| 📂 `.pem` with correct permission | Private key secure (`chmod 400`) |

---

## 📌 Use Cases

- **Production application servers** that must not be publicly accessible
- **Compliance-driven workloads** (e.g., finance, healthcare)
- **Hybrid architectures** requiring secure outbound access
- **Training and testing** secure network patterns

---

## 🚀 How to Use

1. **Clone the repo** and navigate to the directory:

   ```bash
   git clone <your-repo-url>
   cd your-terraform-project
