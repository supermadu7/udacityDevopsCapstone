## The Makefile includes lint
# Dockerfile should pass hadolint
# index.html should pass tidy
  
lint:
	# See local hadolint install instructions:   https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	hadolint Dockerfile
	# This is a linter for html files
	tidy public-html/index.html
