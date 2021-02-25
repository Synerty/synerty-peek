.. _helper_scripts_for_developement:

==============================
Helper Scripts for Development
==============================

There is a :code:`dev-scripts` folder under :code:`synerty-peek` project, where
you can find helper scripts to assist your development of Peek.


git_check_sync.py
-----------------
This script checks synchronisation status between the official Peek repositories
and your forked repositories, your forked repositories and your local git
:code:`dev-peek` codebase.

Usage:

::

    python git_check_sync.py

----

Please create an access token on gitlab if you haven't owned one. Please go
to `<https://gitlab.synerty.com/profile/personal_access_tokens>`_. Type a
name and select an expiration date. Please make sure your check the
following scopes: :code:`api`, :code:`read_user`, :code:`read_repository`.
This means your token only has read access to gitlab.

You copy your token string to :code:`.gitlabtoken` file in the root of
:code:`synerty-peek` project.

----

Run the script by :code:`python git_check_sync.py`.

----

The scripts will start off by checking the difference between your forked
projects on gitlab and the official repositories. Then, it will check your
forked ones with your local git folders. Any difference in these 2 checks
will be prompted in terminal and offer you a choice to proceed or abort the
folder-by-folder synchronisation check happening next.

If you type anything other than :code:`y`, it abort the checks. Otherwise,
it will proceed to folder-by-folder git synchronisation check which takes a
couple of minutes. In this check, it validates that the remote master branches
in your forks on gitlab are in sync of their counterparts in official repository
on gitlab (ORIGIN IN SYNC); that the master branches in your local git
folders are in sync of their remote branches in respective forks (LOCAL IN
SYNC).

----

A summary will display by category of check types with repository info in each.
Example:

::

    ====== Summary ======
    {'localNotInSync': [{1888: 'https://gitlab.synerty.com/your-name/peek/enterprise/peek-plugin-enmac-field-incidents'},
                        {1887: 'https://gitlab.synerty.com/your-name/peek/enterprise/peek-plugin-enmac-field-assessments'},
                        {1860: 'https://gitlab.synerty.com/your-name/peek/community/peek-core-docdb'},
                        {1856: 'https://gitlab.synerty.com/your-name/peek/community/peek-plugin-diagram'},
                        {1850: 'https://gitlab.synerty.com/your-name/peek/community/peek-field-app'}],
     'originNotInSync': []}


git_check_branch.sh
-------------------
This script shows your local branch status. It is like a :code:`git
status` for all repositories in :code:`dev-peek`. It displays all
repositories that are not on :code:`master` branch with the number of commits
unpushed, the number of files untracked to git, and the number of changes
made but not committed.

Usage:

::

    bash git_check_branch.sh

git_optimize.sh
-------------------
This script collects garbage and optimises performace in all your
:code:`dev-peek` projects.

Usage:

::

    bash git_optimize.sh