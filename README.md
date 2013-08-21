Gerrit-sh
=========

Gerrit in your command lines.


Installation
------------

1. Clone this repository 

    ```
    git clone http://github.com/shanesmith/gerrit-sh.git
    ```

2. Run install.sh

    ```
    cd /path/to/cloned/gerrit-sh 
    ./install.sh
    ```

3. Have a beer


Example Usage
-------------

First things first, gerrit-sh is a tool with subcommands, much like git. We can
view the available commands simply invoking gerrit-sh withou any arguments.

`$ gerrit`

    Usage:

      gerrit <command>

    Commands:

      config [<gerrit_name>|--all]
        Show the configured options for <gerrit_name>. If a configuration does not
        exist you will have the option to create one.

    [...]
    

To get things started we need to let gerrit-sh know of the remote server we'll
be dealing with, so we'll use that command we just learned about above.

`$ gerrit config labyrinth`

    I couldn't find a config for "labyrinth", would you like to create one? [Y/n]  y
    Setting up gerrit remote config for "labyrinth"
    Remote Gerrit Host: gerrit.labyrinth.com
    Remote Gerrit Username:  ssmith
    Remote Gerrit Port: 29418 

    Success!

    ---------------
    Conf: labyrinth
    ---------------
    Host: gerrit.labyrinth.com
    User: ssmith
    Port: 29418

Now we can find out what gerrit projects are available for us to clone.

`$ gerrit projects labyrinth`

    icarus
    daedalus
    minos
    
    
Good, let's clone one of them. This will also install the often forgotten
commit-msg git hook fot the project.

`$ gerrit clone labyrinth icarus`

    Cloning project icarus from labyrinth into folder icarus...
    Cloning into 'icarus'...
    [...]
    Setting up commit-msg hook...
    Done!


Now we can start working. We create a topic branch and commit some code to it
like we would normally.

    $ git checkout -b feathers

    [hack, hack, hack...]

    (feathers) $ git commit -m "Gathered feathers"


Let's push that to gerrit.

`(feathers) $ gerrit push`

    Pushing to origin (refs/for/master/feathers)
    [...]
    To ssh://ssmith@gerrit.labyrinth.com:29418/icarus.git
    * [new branch]      HEAD -> refs/for/master/feathers


We'll also want to assign some reviewers to that patch.
    
`(feathers) $ gerrit assign ccanfield bbayles`


Done with our patch, now let's review someone else's. We'll start by taking a
look at what's out there assigned to us.

`(feathers) $ gerrit status`

    9736 [master] "wax" (Curt Canfield)
    9526 [master] "labyrinth" (Howard Higbee)
    9832 [master] "tower" (Bobby Bayles)


Let's grab the patch for wax. We can specify either the
patch id or the topic name.

`(feathers) $ gerrit checkout 9736`

    Getting latest patchset...
    Refspec is refs/changes/36/9736/1
    From ssh://ssmith@gerrit.labyrinth.com:29418/icarus.git
    * branch            refs/changes/36/9736/1 -> FETCH_HEAD
    Switched to a new branch 'wax'


Now we review and we find that while it works alright we think the code could
be cleaned up some, so we submit out review.

`(wax) $ gerrit review`

    Verified: (-1 .. +1) 1
    Code Review: (-2 .. +2) -1
    Message: Not sure if wax is the right way to go


And there you have it. We've cloned a repository, submitted a patch and
reviewed someone else's all without leaving the comfort of our own shell.
Truth be told, in practice the web interface is still very useful, especially
for inline code review comments and for extra information, but I hope this tool
will save you a few window swaps.


Commands
--------
 
```
Usage:

  gerrit <command>

Commands:

  config [<gerrit_name>|--all]
    Show the server configurations for <gerrit_name>, or all configurations, or
    if none specified the configuration of the current project. If a
    configuration does not exist for the specified name you will have the
    option to create one.

  projects <gerrit_name>
    Display the list of projects for which you have access on the <gerrit_name>
    remote.

  clone <gerrit_name> [<project_name> [<destination_folder>]]
    Clone <project_name> from <gerrit_name> into <destination_folder>. This
    will also download and install the often forgotten commit-msg hook for the
    project.

The current working directory must be in a git repository for the following
commands.

  status
    List the open patches for which you are assigned.
    ALIAS: st

  push [<base_branch>]
    Push the current topic branch to the remote based one <base_branch>. If the
    <base_branch> is not provided it is defaulted to master. Essentially the
    same as `git push origin HEAD:refs/for/<base_branch>/<current_branch>`.
    
  draft [<base_branch]
    Same as push, but as a draft 
    (ie: refs/drafts/<base_branch>/<current_branch>)

  assign <reviewer> [<reviewer> ...]
    Assign reviewers by username to the current topic.

  checkout <change_id>|<topic> [<patchset_number>]
    Fetch the patch from remote and create a branch for it of the topic name.
    If the patchset number is not provided it will automatically fetch the
    latest.
    ALIAS: co

  recheckout
    Re-checkout the current topic at the latest patchset, useful when a new
    patchset has been uploaded.
    ALIAS: reco

  review [<verified_score> <code_review_score> [<message>]]
    Give a review of the current checked out patch.

  submit [<message>]
    Submit the patch for merging with verified = 1 and code-review = 2.

  abandon [<message>]
    Abandon the patch.

  pubmit
    Same as `gerrit push && gerrit submit "auto-submit"`
    ALIAS: ninja
    
  ssh [<gerrit_name>] <command>
    Run a custom gerrit server command, see 
    https://review.openstack.org/Documentation/cmd-index.html#_server
```

TODO
----

- Better help documentation (per command? man file?)
- Clean old topic branches (detect merged topic branches?)
- Command to edit an existing config (config --edit default)
- Pushing without topic or when on branch (ie: master)


License
-------

This software is licensed under the MIT License as seen below.

Copyright (c) 2013 Shane Smith

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
