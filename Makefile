
create-buildkite-pipelines:
	@bin/create-pipeline.sh --type pull-request --status-check 
	@bin/create-pipeline.sh --type merge        --status-check

create-buildkite-pipelines-bar-service:
	@bin/create-pipeline.sh --type pull-request --service bar-service --status-check
	@bin/create-pipeline.sh --type merge        --service bar-service --status-check
	@bin/create-pipeline.sh --type deploy       --service bar-service --status-check	

create-buildkite-pipelines-foo-service:
	@bin/create-pipeline.sh --type pull-request --service foo-service --status-check
	@bin/create-pipeline.sh --type merge        --service foo-service --status-check
	@bin/create-pipeline.sh --type deploy       --service foo-service --status-check