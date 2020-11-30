
default:
	echo pass

NAME=phlummox/joplin
TAG=0.1



build:
	docker build -t  $(NAME):$(TAG) .

run:
	docker -D run -e DISPLAY -i -t --rm  --net=host  \
	    $(MOUNT)     		\
	    $(NAME):$(TAG) 

