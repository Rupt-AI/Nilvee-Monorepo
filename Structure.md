📁 DEVOPS_ENTERPRISE_WORKSPACE/
│
├── [COMPLETED] 1. skaffold.yaml              ◄── THE LOCAL FEEDBACK LOOP
│
├── 📁 terraform-infra/                       ◄── PLATFORM RUN-ONCE HARDWARE (6 Files)
│   ├── [COMPLETED] 2. main.tf                
│   ├── [COMPLETED] 3. variables.tf           
│   ├── [COMPLETED] 4. terraform.tfvars       
│   ├── [COMPLETED] 5. outputs.tf             
│   └── 📁 modules/
│       ├── [COMPLETED] 6. vpc/main.tf        
│       └── [COMPLETED] 7. eks/main.tf        
│
└── 📁 enterprise-devops/                     ◄── DEVOPS CONTINUOUS OPERATIONS (51 Files)
    ├── 📁 .github/workflows/
    │   └── [COMPLETED] 8. deployment-pipeline.yaml       
    ├── 📁 ansible/
    │   └── [COMPLETED] 9. node-provisioner.yaml          
    ├── 📁 load-tests/
    │   └── [COMPLETED] 10. staging-stress-test.js        
    ├── 📁 argocd/                            (3 Files)
    │   ├── [COMPLETED] 11. bootstrap-app-of-apps.yaml    
    │   ├── [COMPLETED] 12. app-staging.yaml              
    │   └── [COMPLETED] 13. app-production.yaml           
    ├── 📁 platform/                          (5 Files)
    │   └── manifests/
    │       ├── [COMPLETED] 14. kustomization.yaml        
    │       ├── [COMPLETED] 15. app-deployment.yaml       
    │       ├── [COMPLETED] 16. global-gateway.yaml       
    │       ├── [COMPLETED] 17. network-policy.yaml       
    │       └── [COMPLETED] 18. storage-class.yaml        
    ├── 📁 infrastructure/                    (14 Files)
    │   ├── [COMPLETED] 19. kustomization.yaml            
    │   ├── [COMPLETED] 20. cluster-secret-store.yaml     
    │   ├── [COMPLETED] 21. cert-manager-issuer.yaml      
    │   ├── [COMPLETED] 22. slo-rules.yaml                
    │   ├── [COMPLETED] 23. alertmanager-values.yaml      
    │   ├── [COMPLETED] 24. helm-postgres-operator.yaml   
    │   ├── [COMPLETED] 25. helm-mongodb-operator.yaml    
    │   ├── [COMPLETED] 26. helm-influxdb-operator.yaml   
    │   ├── [COMPLETED] 27. helm-argo-rollouts.yaml       
    │   ├── [COMPLETED] 28. helm-gateway-api-controller.yaml
    │   ├── [COMPLETED] 29. helm-external-dns.yaml        
    │   ├── [COMPLETED] 30. helm-cert-manager.yaml        
    │   ├── [COMPLETED] 31. helm-loki-stack.yaml          
    │   └── [COMPLETED] 32. helm-prometheus-stack.yaml    
    └── 📁 application/                       (26 Files)
        ├── base/                             (14 Files)
        │   ├── [COMPLETED] 33. kustomization.yaml        
        │   ├── 34. helm-values.yaml          
        │   ├── 35. namespaces.yaml           
        │   ├── 36. global-configmap.yaml     
        │   ├── 37. external-secret-template.yaml 
        │   ├── 38. order-service-base.yaml   
        │   ├── 39. order-service-db.yaml     
        │   ├── 40. order-service-migration.yaml
        │   ├── 41. billing-service-base.yaml 
        │   ├── 42. billing-service-redis.yaml
        │   ├── 43. billing-service-worker.yaml
        │   ├── 44. catalog-service-base.yaml  
        │   ├── 45. telemetry-service-base.yaml
        │   └── 46. auth-service-base.yaml    
        └── overlays/                         (12 Files)
            ├── 📁 dev/
            │   ├── 47. kustomization.yaml    
            │   ├── 48. patch-compute-dev.yaml 
            │   ├── 49. dev-routing.yaml      
            │   └── 50. patch-apps-dev.yaml   
            ├── 📁 staging/
            │   ├── 51. kustomization.yaml    
            │   ├── 52. patch-compute-staging.yaml
            │   ├── 53. staging-routing.yaml  
            │   └── 54. patch-apps-staging.yaml
            └── 📁 prod/
                ├── 55. kustomization.yaml    
                ├── 56. canary-rollout.yaml   
                ├── 57. prod-routing.yaml     
                └── 58. external-secret.yaml  
