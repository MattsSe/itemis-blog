# Git: Show Branch in Command Line Promt

I am a heavy Git on command line user. Since i work a lot with branches it is important to know which branch i am currently on. Well i could type `git branch` every time and have a look at the result, but this is a bit tedious. Well there always is the command promt visible on the command line. So what if the promt instead of

```
MacDietrich:xtext-core dietrich$
```

would look like

```
MacDietrich:xtext-core[master] dietrich$
```

There is a solution for that: The magic `PS1` environment variable that defines the promt. We can simply change it to include the current git branch if there is one. I added following lines to my `~/.bash_profile` file

```
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}
export PS1="\h:\W\$(parse_git_branch) \u$ "
```

and reloaded the `~/.bash_profile`  file by typing `source ~/.bash_profile`. Problem solved.