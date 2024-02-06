# RootResolve

**NOTE**: Since October 2023, [direnv](https://direnv.net/) has [introduced support](https://github.com/direnv/direnv/pull/1171) for Powershell!

This is for repositories that store their tools side-by-side with their source code, for reasons including:

* New clients are trivial to provision with no external install steps required.
* Accurate repositories for build can be reproduced for any point in time.
* Source updates can be atomically coupled to tool updates.
* You only have to use one source control technology and not worry about keeping two in sync.

In the presence of multiple branches it can become tricky to locate these tools when you move around the repository tree.
Hard-coding your `PATH` requires constantly switching it when you switch between branches or move the repo around your HDs.

The *no-tool* solution is to store `.bat` files alongside your scripts/data that use hard-coded relative paths to the tools.
While this works really well on small projects it gets unwieldy as the number of call sites grows.

Popular solutions like [direnv](https://direnv.net/) and [autoenv](https://github.com/kennethreitz/autoenv) codify this with
shell-specific hooks that switch between multiple environment profiles on the fly. They work transparently but are complicated,
requiring back-ends for each shell type and with no native Windows `cmd.exe` support.

RootResolve is much simpler and requires more typing but it's a suitable low-tech investment that will work anywhere.

Assuming a layout similar to:

```
repo
   source
      python
         script.py
   extern
      Python
         3.5.1
            python.exe
      Terraform
         0.11.4
            terraform.exe
      Putty
         putty.exe
```

You can place a `rr.cfg` file in your root at `repo\rr.cfg` and add:

```
extern\Python\3.5.1
extern\Terraform\0.11.4
extern\Putty
```

Now, from wherever you are in the `repo` tree you can prefix all commands with `rr` to quickly locate the necessary command:

```
rr python script.py
```

Usage is generally:

```
rr <command> [options]
```
