set positional-arguments

clean-python:
  #!/usr/bin/env python3
  import pathlib
  print("Cleaning *.py[co]")
  current_path = pathlib.Path(".").parent
  [p.unlink() for p in current_path.rglob('*.py[co]')]
  [p.rmdir() for p in current_path.rglob('__pycache__')]


clean-docker-containers:
  #!/usr/bin/env bash
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)


clean-docker-exited-containers:
  #!/usr/bin/env bash
  # docker ps --filter status=exited -q | xargs docker rm
  docker rm $(docker ps --filter status=exited -q)
