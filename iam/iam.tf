resource "aws_iam_user" "myuser" {
    name = "TJ"
  
}

resource "aws_iam_policy" "customPolicy" {
    name = "EC2_Policy1234"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteManagedPrefixList",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:ReplaceRouteTableAssociation",
                "ec2:ModifyManagedPrefixList",
                "ec2:DeleteVpcEndpoints",
                "ec2:ResetInstanceAttribute",
                "ec2:CreateIpamPool",
                "ec2:RejectTransitGatewayMulticastDomainAssociations",
                "ec2:ResetEbsDefaultKmsKeyId",
                "ec2:AttachInternetGateway",
                "ec2:CreateLocalGatewayRouteTable",
                "ec2:ReportInstanceStatus",
                "ec2:ModifyVpnConnectionOptions",
                "ec2:ReleaseIpamPoolAllocation",
                "ec2:DeleteVpnGateway",
                "ec2:CreateRoute",
                "ec2:CreateCoipPoolPermission",
                "ec2:DeleteNetworkInsightsAnalysis",
                "ec2:UnassignPrivateIpAddresses",
                "ec2:DisableImageDeprecation",
                "ec2:DeleteLocalGatewayRouteTable",
                "ec2:CancelExportTask",
                "ec2:DeleteTransitGatewayPeeringAttachment",
                "ec2:ImportKeyPair",
                "ec2:CancelCapacityReservationFleets",
                "ec2:AssociateClientVpnTargetNetwork",
                "ec2:StopInstances",
                "ec2:CreateTransitGatewayPolicyTable"
            ],
            "Resource": "*"
        }
    ]
}    
    EOF

}

resource "aws_iam_policy_attachment" "policyBind" {
    name = "attachment"
    users = [aws_iam_user.myuser.name]
    policy_arn = aws_iam_policy.customPolicy.arn
  
}