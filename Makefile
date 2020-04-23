project_name = $(shell basename $$(pwd))
export project_name

debug ?= 0
export debug

include roles/ansible-role.ansible-playbook/scripts/Makefile