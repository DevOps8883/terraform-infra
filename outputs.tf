output "vpc_id" { value = module.vpc.vpc_id }
output "ec2_instance_id" { value = module.ec2.instance_id }
output "eks_endpoint" { value = module.eks.cluster_endpoint }
output "rds_endpoint" { value = module.rds.rds_endpoint }
output "s3_bucket_name" { value = module.s3.bucket_name }
