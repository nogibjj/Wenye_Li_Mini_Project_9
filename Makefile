install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	python -m pytest -vv --nbval -cov=mylib -cov=main test_*.py *.ipynb

format:	
	black *.py 

lint:
	#disable comment to test speed
	#pylint --disable=R,C --ignore-patterns=test_.*?py *.py mylib/*.py
	#ruff linting is 10-100X faster than pylint
	ruff check *.py mylib/*.py

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

refactor: format lint

deploy:
	#deploy goes here

generate_and_push:
	python main.py
	git config user.name "GitHub Action";
	git config user.email "action@github.com";
	git add .
	git diff-index --quiet HEAD || git commit -m "test"
	git push
		
all: install lint test format deploy
