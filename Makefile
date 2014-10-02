opts=-var-file ~/.heroku/default.tfvars

plan:
	terraform plan $(opts)

apply:
	terraform apply $(opts)

show:
	terraform show terraform.tfstate

push:
	git push `terraform output heroku_app.default.git_url` master:master

browse:
	open http://`terraform output heroku_app.default.name`.herokuapps.com

destroy: destroy.tfstate
	terraform apply destroy.tfstate
destroy.tfstate: terraform.tfstate
	terraform plan -destroy -out destroy.tfstate $(opts)
