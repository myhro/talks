PRESENT_VERSION = v0.1.8

deps:
# Downloading the binary isn't enough on Go >= 1.16, the source is needed as well
# https://github.com/golang/go/issues/43459#issuecomment-800654748
	go install golang.org/x/tools/cmd/present@$(PRESENT_VERSION)
	go get -d golang.org/x/tools/cmd/present@$(PRESENT_VERSION)

serve:
	@present -base $(GOPATH)/pkg/mod/golang.org/x/tools@$(PRESENT_VERSION)/cmd/present
