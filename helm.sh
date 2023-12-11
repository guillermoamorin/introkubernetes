helm uninstall my-release
helm package myOdoo/
helm install my-release ./myOdoo-0.1.0.tgz