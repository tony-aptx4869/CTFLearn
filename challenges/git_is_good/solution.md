# [Git Is Good](https://ctflearn.com/challenge/104) (30)
Before even downloading the [file](https://mega.nz/#!3CwDFZpJ!Jjr55hfJQJ5-jspnyrnVtqBkMHGJrd6Nn_QqM7iXEuc), I have a feeling the `.git/` directory is going to be important. <br />
Unzipping the file, we find `flag.txt` inside, but the flag has been redacted. <br />
We can use `ls -a` to see hidden files in a directory, this one contains `.git` <br />
Since we know all the changes to this file have been tracked by git, we can view them with `git log`: <br />
```
$ git log

commit d10f77c4e766705ab36c7f31dc47b0c5056666bb (HEAD -> master)
Author: LaScalaLuke <lascala.luke@gmail.com>
Date:   Sun Oct 30 14:33:18 2016 -0400

    Edited files

commit 195dd65b9f5130d5f8a435c5995159d4d760741b
Author: LaScalaLuke <lascala.luke@gmail.com>
Date:   Sun Oct 30 14:32:44 2016 -0400

    Edited files

commit 6e824db5ef3b0fa2eb2350f63a9f0fdd9cc7b0bf
Author: LaScalaLuke <lascala.luke@gmail.com>
Date:   Sun Oct 30 14:32:11 2016 -0400

    edited files

```
The commit we are on is the one that says `HEAD`, we can use the commit hashes to go back in time. <br />
Let's go the the one from `14:32:44` with `git checkout 195dd65b9f5130d5f8a435c5995159d4d760741b` <br />
Now that we are on this commit, we can use `cat flag.txt` to see the prior contents: <br />
`flag{protect_your_git}` <br />
