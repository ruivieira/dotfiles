#!/usr/bin/env zunit

@test 'pyenv creation' {
	load ../.functions.zsh
	mkdir -p ~/tmp/zsh_tmp_pyenv_test
	cd ~/tmp/zsh_tmp_pyenv_test
	pyenvcreate
	assert ~/.pyenv/versions/3.6.5/envs/zsh_tmp_pyenv_test exists
	rm -Rf ~/.pyenv/versions/3.6.5/envs/zsh_tmp_pyenv_test
}
