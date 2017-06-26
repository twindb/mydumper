PLATFORM := $(shell if test -z "${PLATFORM}"; then echo "centos"; else echo ${PLATFORM}; fi)

.PHONY: docker-start
docker-start:
	@docker run \
		-v $(shell pwd):/mydumper \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-it \
		"twindb/omnibus-${PLATFORM}" \
		bash -l
