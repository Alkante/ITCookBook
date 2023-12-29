# CVS

## Vocabulaire

    Une révision : employé pour caractériser une version d'un fichier seul
    Une version : plutôt employé pour parler d'une version du projet/module ou d'une version logicielle
    Repository : nom donné au répertoire d'accueil au niveau du serveur CVS
    Module : nom caractérisant un projet/sous-projet disponible sur le serveur CVS




CVS commands are:

        add          Add a new file/directory to the repository
        admin        Administration front end for rcs
        annotate     Show last revision where each line was modified
        commit       Check files into the repository
        diff         Show differences between revisions
        edit         Get ready to edit a watched file
        editors      See who is editing a watched file
        export       Export sources from CVS, similar to checkout
        history      Show repository access history
        import       Import sources into CVS, using vendor branches
        init         Create a CVS repository if it doesn't exist
        log          Print out history information for files
        login        Prompt for password for authenticating server
        logout       Removes entry in .cvspass for remote repository
        ls           List files available from CVS
        pserver      Password server mode
        rannotate    Show last revision where each line of module was modified
        rdiff        Create 'patch' format diffs between releases
        release      Indicate that a Module is no longer in use
        remove       Remove an entry from the repository
        rlog         Print out history information for a module
        rls          List files in a module
        rtag         Add a symbolic tag to a module
        server       Server mode
        tag          Add a symbolic tag to checked out version of files
        unedit       Undo an edit command
        update       Bring work tree in sync with repository
        version      Show current CVS version(s)
        watch        Set watches
        watchers     See who is watching a file



### Prendre une copie d'un projet existant
Cette commande permet d'obtenir une copie de travail sous control cvs.
Cette commande doit être lancer dans le repertoire qui contiendra le module (projet)

	cvs checkout

ou

	cvs co

ou

	cvs get

```
  cvs checkout [-ANPRcflnps] [-r rev] [-D date] [-d dir]
  [-j rev1] [-j rev2] [-k kopt] modules...
      -A      Reset any sticky tags/date/kopts.
      -N      Don't shorten module paths if -d specified.
      -P      Prune empty directories.
      -R      Process directories recursively.
      -c      "cat" the module database.
      -f      Force a head revision match if tag/date not found.
      -l      Local directory only, not recursive
      -n      Do not run module program (if any).
      -p      Check out files to standard output (avoids stickiness).
      -s      Like -c, but include module status.
      -r rev  Check out revision or tag. (implies -P) (is sticky)
      -D date Check out revisions as of date. (implies -P) (is sticky)
      -d dir  Check out into dir instead of module name.
      -k kopt Use RCS kopt -k option on checkout. (is sticky)
      -j rev  Merge in changes made between current revision and rev.
```





### Initialiser un projet un travail existant qui n'est pas sous cvs
	import -m "mon message" nommodule1 vendor_tag release_tag

### Exporter une copie via un tag  pour diffusion (sans csv)
	cvs export -r tag1 monmodule1

### Administration
#### Information sur les fichier du répertoire
	cvs status
#### Information sur un ou plusieur fichier
	cvs status file1 file2 file3
