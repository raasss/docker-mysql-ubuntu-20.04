.PHONY: build
build:
	docker buildx build --progress plain \
	--tag localhost/mysql-ubuntu-20.04:latest \
	--platform linux/amd64,linux/arm/v7,linux/arm64 .
