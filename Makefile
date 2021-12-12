PRESENT_CMD = $(GOBIN)/present -base $(GOPATH)/pkg/mod/golang.org/x/tools@$(PRESENT_VERSION)/cmd/present -content slides/ -use_playground
PRESENT_VERSION = v0.1.8
URL = 127.0.0.1:3999

build: clean serve-background mirror stop

clean:
	rm -rf $(URL)/

deps:
# Downloading the binary isn't enough on Go >= 1.16, the source is needed as well
# https://github.com/golang/go/issues/43459#issuecomment-800654748
	go install golang.org/x/tools/cmd/present@$(PRESENT_VERSION)
	go get -d golang.org/x/tools/cmd/present@$(PRESENT_VERSION)

mirror:
	wget --mirror --adjust-extension $(URL)
	wget -O $(URL)/static/styles.css $(URL)/static/styles.css

serve:
	$(PRESENT_CMD)

serve-background:
	$(PRESENT_CMD) &
	timeout 10s bash -c 'until curl -I $(URL); do sleep 0.5; done'

stop:
	pkill present
