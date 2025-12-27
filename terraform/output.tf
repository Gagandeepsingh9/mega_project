output "Jenkins_instance_public_ip" {
    value = aws_instance.my_instance.public_ip
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
